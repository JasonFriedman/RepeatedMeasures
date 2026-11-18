"""Tests of the Python groundwork. Run from the python directory:  python -m pytest"""
import time
from pathlib import Path

import pytest

from repeatedmeasures import ProtocolError, load_protocol, load_schema
from repeatedmeasures.devices import DeviceClient, SimulatedDevice
from repeatedmeasures.messages import Command, Event
from repeatedmeasures.protocol import parse_matrix, parse_number

ROOT = Path(__file__).resolve().parents[2]
PROTOCOLS = sorted((ROOT / "sampleexperiments" / "protocols").glob("*.xml"))
# Sample protocols that the current MATLAB validation rejects as well (the committed XML
# files are older than the checks, see docs/BUGS.md)
KNOWN_INVALID = {
    "CopyShapes.xml", "MaleFemale.xml", "MaleFemaleButton.xml", "MaleFemaleOpto.xml",
    "MaskedPriming.xml", "NCE.xml", "QuestImages.xml", "RDK.xml", "SequenceLearning.xml",
    "TMSTrigger.xml",
}


def test_schema_has_everything():
    schema = load_schema()
    assert {"setup", "trial", "devices", "stimulus", "targetType", "starttrial"} <= set(schema)
    assert "tablet" in schema["devices"] and "liberty" in schema["devices"]
    assert "pointToPoint" in schema["targetType"] and "keyboard" in schema["starttrial"]


def test_number_and_matrix_parsing():
    assert parse_number("Inf") == float("inf")
    assert parse_matrix("[1 2;3 4]") == [[1, 2], [3, 4]]
    assert parse_matrix("[0,0,0]") == [[0, 0, 0]]
    assert parse_matrix("5") == [[5]]


@pytest.mark.parametrize("path", PROTOCOLS, ids=lambda p: p.name)
def test_sample_protocols_are_read(path):
    if path.name in KNOWN_INVALID:
        with pytest.raises(ProtocolError):
            load_protocol(path)
    else:
        protocol = load_protocol(path)
        assert protocol.devices and protocol.trials


def write(tmp_path, body):
    path = tmp_path / "p.xml"
    path.write_text(f'<?xml version="1.0" ?><experimentDescription>{body}</experimentDescription>')
    return path


SETUP = "<setup><keyboard><server>localhost</server><port>3002</port></keyboard></setup>"
TRIAL = "<trial><stimulus>fixation</stimulus><recordingTime>2</recordingTime><filename>{}</filename></trial>"


def test_valid_protocol(tmp_path):
    protocol = load_protocol(write(tmp_path, SETUP + TRIAL.format("a") + TRIAL.format("b")))
    assert [t.parameters["filename"] for t in protocol.trials] == ["a", "b"]
    assert protocol.trials[0].stimulus[0] == "fixation"
    assert protocol.trials[0].start[0] == "dontWait" and protocol.trials[0].response[0] == "dummy"
    assert protocol.devices["keyboard"]["port"] == 3002
    assert protocol.setup["monitorWidth"] == 70  # default from the MATLAB code


@pytest.mark.parametrize(
    "body, message",
    [
        (TRIAL.format("a"), "setup and trial"),
        ("<setup><monitorWidth>50</monitorWidth></setup>" + TRIAL.format("a"), "at least one recording device"),
        (SETUP + TRIAL.format("a") + TRIAL.format("a"), "Repeated filenames"),
        (SETUP + "<trial><stimulus>fixation</stimulus><filename>a</filename></trial>", "Must specify recordingTime"),
        (SETUP + "<trial><stimulus>nothing</stimulus><recordingTime>1</recordingTime><filename>a</filename></trial>", "no stimulus called nothing"),
        (SETUP + "<trial><stimulus>fixation</stimulus><recordingTime>1</recordingTime></trial>", "filename when recording"),
        (SETUP + "<trial><stimulus>fixation</stimulus><recordingTime>1</recordingTime><filename>a</filename><colour>1</colour></trial>", "Unknown field colour"),
        (SETUP + "<trial><stimulus>fixation</stimulus><recordingTime>1</recordingTime><filename>a</filename><backgroundColor>[0 0]</backgroundColor></trial>", "width of matrix"),
        (SETUP + "<trial><stimulus><showImage><stimuli>2</stimuli></showImage></stimulus><recordingTime>0</recordingTime><recording>0</recording></trial>", "not enough images"),
    ],
)
def test_invalid_protocols(tmp_path, body, message):
    with pytest.raises(ProtocolError, match=message):
        load_protocol(write(tmp_path, body))


def test_codes_match_matlab():
    text = (ROOT / "matlab" / "messagecodes.m").read_text()
    assert f"codes.getsample = {Command.GET_SAMPLE.value};" in text
    assert f"codes.markEvent = {Command.MARK_EVENT.value};" in text
    assert f"codes.firstFrame = {Event.FIRST_FRAME.value};" in text
    assert f"codes.tactored = {Event.TACTORED.value};" in text


def test_simulated_device_session(tmp_path):
    server = SimulatedDevice(rate=500).start()
    try:
        client = DeviceClient(server.host, server.port)
        assert client.send("GET_SAMPLE") is None  # nothing before sampling starts
        client.send("SETUP_RECORDING", filename=str(tmp_path / "trial1"), max_seconds=2)
        client.send("START_RECORDING")
        client.send("MARK_EVENT", value=Event.FIRST_FRAME)
        time.sleep(0.3)
        sample = client.send("GET_SAMPLE")
        assert len(sample) == 4  # x, y, time, marker
        client.send("STOP_RECORDING")
        summary = client.send("GET_DATA_SUMMARY")
        client.send("SAVE_FILE")
        with pytest.raises(RuntimeError, match="Unknown command"):
            client.send("NOT_A_COMMAND")
        client.close()
    finally:
        server.close()
    assert summary["samples"] > 50
    rows = (tmp_path / "sim_trial1.csv").read_text().splitlines()
    assert len(rows) == summary["samples"]
    assert any(float(r.split(",")[-1]) == Event.FIRST_FRAME for r in rows)
