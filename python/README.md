# Python groundwork

A small, tested starting point for a Python port (see `docs/porting/FEASIBILITY.md`).
No dependencies beyond the standard library (Python 3.10 or later).

```
cd python
python -m pytest          # 33 tests
```

* `repeatedmeasures/schema.json` – every protocol option, exported from the MATLAB code
  with `protocolSchemaExport` (re-export it when the MATLAB code changes).
* `repeatedmeasures/protocol.py` – reads the existing XML protocol files and performs the
  same checks as `readParameters` / `validate`. It accepts and rejects the same sample
  protocols as the MATLAB version.
* `repeatedmeasures/messages.py` – the command and event codes.
* `repeatedmeasures/devices.py` – a device protocol that is not tied to MATLAB (one line of
  JSON per message over TCP), with a server base class (the equivalent of
  `@socketserver/listen.m`), a client and a simulated device.

```python
from repeatedmeasures import load_protocol
protocol = load_protocol("../sampleexperiments/protocols/CentreOut.xml")
for trial in protocol.trials:
    print(trial.number, trial.stimulus[0], trial.response[0], trial.parameters["recordingTime"])
```
