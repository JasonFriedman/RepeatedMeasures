# Porting RepeatedMeasures away from MATLAB: feasibility and effort

## Summary

* **Recommended target: Python**, with PsychoPy for the display / timing / audio, and the
  device servers kept as separate processes that speak a language-neutral protocol.
* **Feasible: yes.** The architecture already separates the experiment (client) from the
  devices (servers) over a socket, and every option is declared as data in the code. Both
  carry over directly. The hard part is not the language: it is re-verifying each device
  and the timing on real hardware.
* **Effort: about 4–6 person-months** for the core plus the devices in everyday use
  (keyboard, mouse, tablet, Liberty, serial / Arduino triggers, force sensors, audio), and
  roughly **8–11 person-months** for everything in the repository. Estimates are
  mine, from the size and nature of the code (table below); they assume someone who knows
  the toolbox and has the devices at hand.
* **Windows, macOS, Linux: yes** for the experiment program. Individual devices remain
  limited by their vendor drivers, exactly as now.
* **Android / iOS: not for the full toolbox.** Realistic only as a touch-screen
  "tablet experiment" client; see below.

Groundwork that exists now (in this repository):

| Piece | Where | Status |
|---|---|---|
| Machine-readable list of every protocol option | `python/repeatedmeasures/schema.json`, exported from the MATLAB code by `protocolSchemaExport` | done |
| Reader / validator for the existing XML protocols | `python/repeatedmeasures/protocol.py` | done; accepts and rejects the same 19 sample protocols as MATLAB |
| Command and event codes | `python/repeatedmeasures/messages.py` | done |
| Device protocol not tied to MATLAB, server base class, client, simulated device | `python/repeatedmeasures/devices.py` | working prototype, 1 simulated device |
| Behavioural reference to port against | `tests/` (50 tests incl. whole simulated experiments) | done |

## Why Python

| | Python | C++ (Qt) | JavaScript (browser) | Julia / Octave |
|---|---|---|---|---|
| Free, widely used in the field | yes (PsychoPy is the common free alternative to Psychtoolbox) | yes, but few labs | yes (jsPsych, PsychoJS) | Octave: runs much of the code already, but depends on Psychtoolbox-for-Octave (Linux mainly) and old-style classes |
| Display timing | PsychoPy / pyglet; frame-accurate flips, the `psychtoolbox` Python package gives the same keyboard and audio engines as now | best | limited to the browser's frame callbacks | – |
| Devices | serial (pyserial), NI-DAQ (nidaqmx), MCC (mcculw / uldaq), BLE (bleak), USB (pyusb/libusb), TCP devices; vendor DLLs through ctypes/cffi | native SDKs directly | essentially none (no USB trackers, DAQ) | – |
| Students can read and modify it | yes | hard | yes | yes |
| Windows / macOS / Linux | yes | yes | yes | partial |
| Android / iOS | weak (see below) | possible with Qt, large effort | **yes** | no |

C++ is only attractive for the device servers that wrap a vendor SDK – and those can stay
small C++ programs (they already contain C/C++ mex code) behind the same socket protocol.
A browser version is the only cheap route to phones, but cannot reach the trackers.

Current state of the Python options (checked November 2026): PsychoPy is actively released
(2026.2.x, Python 3.11, native Apple-silicon builds, low-latency audio without needing
the psychtoolbox backend). Python on phones: iOS and Android became officially supported
CPython platforms in 3.13 (tier 3) and Kivy / BeeWare build apps from Python, but PsychoPy
and the device libraries do not run there.

## Architecture of the port

Keep what works, change two things.

1. **Keep** the three layers: protocol file → experiment loop (stimulus / start / response
   objects called every frame) → device clients talking to device servers.
2. **Keep** the XML protocol format, so existing protocols and `generateProtocol.m` files
   keep working during the transition (the Python reader already reads them).
3. **Change the wire format.** msocket sends serialized MATLAB variables, so only MATLAB
   can talk to a server. `devices.py` uses one line of JSON per message. This is what makes
   a gradual migration possible: a server can be ported (or wrapped) one device at a time,
   in whichever language its SDK prefers, and can run on another computer.
4. **Change the server loop.** `listen.m` alternates between sampling and message handling
   in one thread; in the port sampling runs in its own thread at the device rate.
5. Replace old-style classes and `eval`/`get`/`set` by ordinary classes; replace the
   parameter structs by the schema (already extracted).

A migration path that never leaves you without a working system:

1. Protocol + schema + simulated devices in Python (done), experiment loop with PsychoPy
   for keyboard and mouse, validated against the MATLAB test suite's scenarios.
2. A small MATLAB adapter so the *existing* MATLAB servers answer the JSON protocol: all
   devices are then usable from the Python experiment immediately.
3. Port servers device by device, most used first; retire MATLAB when the last one goes.

## Devices

"Same OS as now" means the vendor driver decides; the port does not make it worse.

| Device (class) | How it is reached today | Python route | Platforms | Risk |
|---|---|---|---|---|
| keyboard, mouse | Psychtoolbox | PsychoPy / `psychtoolbox` package | Win, mac, Linux | low |
| tablet (Wacom) | WinTab mex | pyglet tablet API (used by PsychoPy), or Qt tablet events | Win, mac, Linux | low–medium (pressure, rate) |
| serialport, tactors, arduino, parallel triggers | MATLAB serial / io | pyserial; `psychopy.parallel` | all (parallel: Win, Linux) | low |
| NIDAQ | NI-DAQmx | `nidaqmx` | Win, Linux | low |
| MCDAQ / DAQ (Measurement Computing) | MCC Universal Library | `mcculw` (Windows), `uldaq` (Linux, mac) | Win, Linux, mac | low–medium |
| forcesensors (via DAQ), ATI wireless F/T | DAQ / TCP | as above / plain sockets | all | low |
| gazepoint | TCP (Open Gaze API) | plain sockets | client: all | low |
| gopro | HTTP / BLE | Open GoPro Python SDK | all | low |
| bluetera, redamber (BLE IMUs) | vendor code | `bleak` | all | medium (protocol details) |
| liberty, fastrak, g4 (Polhemus) | PDI SDK mex (Windows) | ctypes wrapper of PDI on Windows; on Linux open-source libusb drivers exist for Liberty | Win (+ Linux for Liberty) | **medium–high**, most used tracker: do first |
| trakStar (Ascension / NDI) | ATC3DG DLL | ctypes wrapper of the same DLL | Win | medium |
| optotrak (NDI) | OptotrakToolbox mex | wrap the NDI API (ctypes / small C++ server) | Win | **high** (large API, 10 C files today) |
| glove (CyberGlove), glovetracker | serial / VHT | pyserial for raw glove data | Win | medium, legacy hardware |
| VR stimulus (`vrstimulus`), RDK (`VCRDM`, `dots`) | Psychtoolbox OpenGL | PsychoPy `DotStim` / pyglet OpenGL | all | medium (VR: high) |

## Effort

Lines are non-comment MATLAB lines in the repository today.

| Part | Lines now | Estimate | Notes |
|---|---|---|---|
| Protocol reading, schema, validation, docs generation | ~600 | done | this groundwork |
| Experiment loop (`runexperiment`, resources, feedback, beeps, triggers, DRT, audio, staircases/QUEST) | ~2300 | 5–7 weeks | the part where timing must be re-validated with a photodiode / audio loopback |
| Socket base, device protocol, recording to file, simulated devices | ~630 | 1–2 weeks | prototype exists |
| 16 stimuli | ~1570 | 3–4 weeks | RDK and video are the long ones; VR extra (2+ weeks) |
| 16 responses + 10 starts | ~1850 | 3–4 weeks | mostly geometry on the latest sample; straightforward, well covered by simulated tests |
| Device clients + servers (26 devices) | ~5900 + ~6600 C/C++ | 2–5 days each for serial / TCP / DAQ devices; 2–3 weeks each for Polhemus, trakStar; 4+ weeks Optotrak | needs each device on the bench |
| Tests, packaging, documentation, porting the sample experiments | – | 3–4 weeks | |

Everyday subset (core, keyboard, mouse, tablet, Liberty, serial/Arduino, DAQ force
sensors, the common stimuli and responses): **4–6 months**. Everything: **8–11 months**.

## Risks

* **Timing equivalence.** Published results depend on the frame and audio timing of
  Psychtoolbox. Budget time to measure, not just to code.
* **Vendor SDKs** (Polhemus, NDI) are Windows-only and unchanged by the port; "runs on
  Linux / mac" applies to the experiment program and the simple devices.
* **Two code bases during the transition.** Mitigated by the shared schema and by keeping
  the XML format; the Python tests compare against the MATLAB sample protocols.
* **Analysis code** reads the CSV files and marker codes: keep both identical (the
  prototype writes the same layout: data columns, time, marker).

## Android / iOS

A phone or tablet cannot drive the trackers or DAQ boards, so only touch-screen tasks make
sense there (pointing, tracing, mirror-game-like tasks, DRT). Two realistic options,
both additional to the estimates above:

* a **browser client** (JavaScript) that reads the same protocol (converted to JSON) and
  implements a subset of stimuli / responses for touch input – roughly 2–3 months, runs on
  anything with a browser, timing limited to the display's refresh callbacks;
* a **Kivy / BeeWare app** in Python reusing the protocol reader – similar effort, less
  certain tooling.

## Suggested next step

Port the experiment loop for keyboard + mouse on PsychoPy (step 1 above) and run the
MaleFemale and MouseWords samples in both systems side by side. That is about 6 weeks,
gives a usable result for student projects that only need those devices, and tells you
whether the timing and the effort estimates hold before committing to the trackers.
