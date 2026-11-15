"""Read and validate RepeatedMeasures protocol files (the same XML files as MATLAB).

This is a port of matlab/readParameters.m and of the checks in @experiment/experiment.m,
readTrialParameters.m and validate.m. The list of options is not written here: it is in
schema.json, which is exported from the MATLAB code with protocolSchemaExport, so the two
implementations cannot drift apart while both exist.
"""
from __future__ import annotations

import json
import math
import re
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

SCHEMA_FILE = Path(__file__).with_name("schema.json")
_MATRIX_TYPE = re.compile(r"^matrix(?:_([0-9]+|n)_([0-9]+|n))?$")


class ProtocolError(ValueError):
    """A problem in a protocol file (the message says where)."""


def load_schema(path: str | Path = SCHEMA_FILE) -> dict:
    with open(path, encoding="utf-8") as fp:
        return json.load(fp)


# --------------------------------------------------------------------------- XML


def _xml_to_value(element: ET.Element) -> Any:
    """Convert an XML element the way xmltree's convert does in MATLAB.

    Leaves become strings, elements with children become dicts, and repeated children
    with the same name become lists.
    """
    children = list(element)
    if not children:
        return (element.text or "").strip()
    out: dict[str, Any] = {}
    for child in children:
        value = _xml_to_value(child)
        if child.tag in out:
            if not isinstance(out[child.tag], list):
                out[child.tag] = [out[child.tag]]
            out[child.tag].append(value)
        else:
            out[child.tag] = value
    return out


# ------------------------------------------------------------------- value parsing


def parse_number(text: str) -> float:
    """str2double: 'Inf', '-Inf' and 'NaN' are allowed."""
    t = text.strip().lower()
    if t in ("inf", "+inf"):
        return math.inf
    if t == "-inf":
        return -math.inf
    if t == "nan":
        return math.nan
    return float(t)


def parse_matrix(text: str) -> list[list[float]]:
    """str2num for the matrices written by struct2xml: '[1 2;3 4]', '[1,2,3]', '5'."""
    t = text.strip()
    if t.startswith("[") and t.endswith("]"):
        t = t[1:-1]
    if not t.strip():
        return []
    rows = []
    for row in t.split(";"):
        items = [x for x in re.split(r"[\s,]+", row.strip()) if x]
        if items:
            rows.append([parse_number(x) for x in items])
    width = {len(r) for r in rows}
    if len(width) > 1:
        raise ValueError("the rows have different lengths")
    return rows


def _convert(value: Any, param: dict, where: str, schema: dict) -> Any:
    kind = param["type"]
    if kind == "struct":
        if isinstance(value, list):
            return [_read_params(v, param["children"], f"{where}[{i + 1}]", schema) for i, v in enumerate(value)]
        return _read_params(value, param["children"], where, schema)
    if kind == "oneof":
        items = value if isinstance(value, list) else [value]
        out = []
        for item in items:
            if not isinstance(item, dict) or len(item) != 1:
                raise ProtocolError(f"{where}: expected one of {sorted(param['children'])}")
            (name, inner), = item.items()
            if name not in param["children"]:
                raise ProtocolError(f"{where}: unknown option {name}")
            out.append({name: _read_params(inner, param["children"][name], f"{where}.{name}", schema)})
        return out if isinstance(value, list) else out[0]
    if kind == "ignore":
        return value
    if kind == "cellarray":
        return value if isinstance(value, list) else [value]
    if not isinstance(value, str):
        raise ProtocolError(f"{where}: expected a value, found a section")
    if kind == "string":
        return value
    try:
        if kind in ("number", "boolean"):
            number = parse_number(value)
            if kind == "boolean" and number not in (0, 1):
                raise ProtocolError(f"{where} needs to be boolean (0 or 1)")
            return number
        match = _MATRIX_TYPE.match(kind)
        if match:
            matrix = parse_matrix(value)
            rows, cols = match.groups()
            if rows and rows != "n" and len(matrix) != int(rows):
                raise ProtocolError(f"{where}: height of matrix is wrong (should be {rows})")
            if cols and cols != "n" and matrix and len(matrix[0]) != int(cols):
                raise ProtocolError(f"{where}: width of matrix is wrong (should be {cols})")
            return matrix
    except ValueError as err:
        raise ProtocolError(f"{where}: cannot read '{value}' as {kind} ({err})") from None
    raise ProtocolError(f"{where}: unknown type {kind} in the schema")


def _read_params(values: Any, params: list[dict], where: str, schema: dict) -> dict:
    """Port of readParameters: defaults, conversion, unknown and missing fields."""
    if isinstance(values, str):
        if values.strip():
            raise ProtocolError(f"{where} is expected to be a section with fields")
        values = {}
    by_name = {p["name"]: p for p in params}
    out = {p["name"]: p["default"] for p in params}
    for name, value in values.items():
        if name not in by_name:
            raise ProtocolError(f"Unknown field {name} in {where}")
        out[name] = _convert(value, by_name[name], f"{where}.{name}", schema)
    for p in params:
        if p["required"] in (1, 3) and p["name"] not in values and p["type"] != "ignore":
            raise ProtocolError(f"Must specify {p['name']} for {where}")
    return out


def _read_class(value: Any, kind: str, where: str, schema: dict) -> tuple[str, dict]:
    """stimulus / targetType / starttrial: a name, or a section with one named child."""
    if isinstance(value, str):
        name, inner = value, {}
    elif isinstance(value, dict) and len(value) == 1:
        (name, inner), = value.items()
    else:
        raise ProtocolError(f"{where}: expected the name of a {kind}")
    if name not in schema[kind]:
        raise ProtocolError(f"{where}: there is no {kind} called {name}")
    return name, _read_params(inner, schema[kind][name], f"{where}.{name}", schema)


# ------------------------------------------------------------------------ protocol


@dataclass
class Trial:
    number: int
    parameters: dict
    stimulus: tuple[str, dict]
    response: tuple[str, dict]
    start: tuple[str, dict]

    @property
    def recording(self) -> bool:
        value = self.parameters.get("recording")
        return value is None or value != 0


@dataclass
class Protocol:
    setup: dict
    devices: dict[str, dict]
    trials: list[Trial] = field(default_factory=list)
    source: str = ""


def load_protocol(path: str | Path, schema: dict | None = None) -> Protocol:
    """Read a protocol file and check it (raises ProtocolError with the reason)."""
    schema = schema or load_schema()
    root = _xml_to_value(ET.parse(path).getroot())
    if not isinstance(root, dict) or "setup" not in root or "trial" not in root:
        raise ProtocolError("The protocol file must have the sections setup and trial (and optionally common)")
    unknown = set(root) - {"setup", "trial", "common"}
    if unknown:
        raise ProtocolError(f"Unknown field in protocol file: {sorted(unknown)[0]}")

    setup_raw = dict(root["setup"]) if isinstance(root["setup"], dict) else {}
    devices = {}
    for name in list(setup_raw):
        if name in schema["devices"]:
            devices[name] = _read_params(setup_raw.pop(name), schema["devices"][name], name, schema)
    if not devices:
        raise ProtocolError("There must be at least one recording device")
    setup = _read_params(setup_raw, schema["setup"], "setup", schema)

    raw_trials = root["trial"] if isinstance(root["trial"], list) else [root["trial"]]
    common = root.get("common") or {}
    trials: list[Trial] = []
    filenames: dict[str, int] = {}
    for number, raw in enumerate(raw_trials, start=1):
        raw = {**raw, **common} if isinstance(common, dict) else dict(raw)
        where = f"trial {number}"
        if "stimulus" not in raw:
            raise ProtocolError(f"{where}: each trial must specify a stimulus")
        stimulus = _read_class(raw.pop("stimulus"), "stimulus", f"{where}.stimulus", schema)
        response = _read_class(raw.pop("targetType", "dummy"), "targetType", f"{where}.targetType", schema)
        start = _read_class(raw.pop("starttrial", "dontWait"), "starttrial", f"{where}.starttrial", schema)
        params = _read_params(raw, [p for p in schema["trial"] if p["name"] not in ("stimulus", "targetType", "starttrial")], where, schema)
        trial = Trial(number, params, stimulus, response, start)
        filename = params.get("filename") or ""
        if trial.recording and not filename:
            raise ProtocolError(f"{where}: must specify a filename when recording")
        if filename:
            if filename in filenames:
                raise ProtocolError(f"Repeated filenames: {filename} is used by trials {filenames[filename]} and {number}")
            filenames[filename] = number
        _check_resources(trial, setup, devices, where)
        trials.append(trial)
    return Protocol(setup=setup, devices=devices, trials=trials, source=str(path))


def _count(value: Any) -> int:
    if value is None or value == "":
        return 0
    return len(value) if isinstance(value, list) else 1


def _check_resources(trial: Trial, setup: dict, devices: dict, where: str) -> None:
    """The cross checks of readTrialParameters and of the class constructors."""
    p = trial.parameters
    beeps = p.get("beep")
    for beep in (beeps if isinstance(beeps, list) else [beeps] if beeps else []):
        number = beep.get("beepNumber") or 0
        if number > 0 and number > _count(setup.get("beeps")):
            raise ProtocolError(f"{where}: beep {int(number)} is not defined in the setup section")
    triggers = p.get("trigger")
    for trigger in (triggers if isinstance(triggers, list) else [triggers] if triggers else []):
        kind = trigger["type"]
        needs = {"serial": "serial", "parallel": "parallel"}
        if kind in needs and not setup.get(needs[kind]):
            raise ProtocolError(f"{where}: {kind} triggers need {kind} in the setup section")
        device_needed = {"arduino": "arduino", "NIDAQ": "NIDAQ", "serialportserver": "serialport"}
        if kind in device_needed and device_needed[kind] not in devices:
            raise ProtocolError(f"{where}: {kind} triggers need the device {device_needed[kind]}")
    if p.get("DRT") and "keyboard" not in devices:
        raise ProtocolError(f"{where}: cannot perform DRT without recording from the keyboard")
    name, options = trial.stimulus
    images = _count(setup.get("images"))
    if name == "showImage" and options["stimuli"] > images:
        raise ProtocolError(f"{where}: there are not enough images in setup.images")
    if name == "images" and options["stimuli"] and max(r[0] for r in options["stimuli"]) > images:
        raise ProtocolError(f"{where}: there are not enough images in setup.images")
