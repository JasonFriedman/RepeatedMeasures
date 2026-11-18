# Tests for RepeatedMeasures

The tests run **with or without devices plugged in**, with or without the Psychtoolbox,
in MATLAB or in GNU Octave.

```matlab
cd tests
results = runAllTests;                % everything that can run on this computer
results = runAllTests('simulated');   % force the simulated Psychtoolbox (fast, no window)
results = runAllTests('auto','readParameters');   % only suites matching a pattern
results = runAllTests('hardware');    % smoke test of the real devices (see below)
```

From the command line / continuous integration (see `.github/workflows/tests.yml`):

```
octave --no-gui --eval "cd tests; r = runAllTests('simulated'); exit(any(strcmp({r.status},'failed')))"
matlab -batch "cd tests; r = runAllTests('simulated'); exit(any(strcmp({r.status},'failed')))"
```

## What is tested

| Suite | What it checks |
|---|---|
| `test_readParameters` | parsing and checking of protocol parameters (types, matrix sizes, required / unknown fields, nested structs, lists, parent classes) |
| `test_schema` | every client / stimulus / response / start / staircase class describes its parameters consistently, defaults match the declared types, the class hierarchy matches `parentclassname`, command codes are unique, `makeProtocolDocumentation` runs and `docs/` is up to date |
| `test_protocols` | XML round trip, all protocols in `sampleexperiments/protocols` load, every `generate*Protocol.m` sample produces a protocol that validates, and broken protocols give the expected error messages |
| `test_protocolBuilder` | the protocol builder: the schema matches the classes, options are found, mistakes are reported with suggestions, designs / blocks, and a builder protocol equals the hand-written sample |
| `test_run_experiment` | whole experiments are run through `runexperiment` (keyboard, mouse and a generic simulated device): trial start, responses, feedback, reaction times, timeouts, beeps, triggers, event markers, quitting with `q`, and the files that are written |
| `hardware/test_devices` | (only in `'hardware'` mode) records 2 s from each real device listed in `hardware/rmtestHardwareConfig.m` and checks the samples, the data file and the event marker |

## How it works without devices

* **Simulated device servers** (`stubs/msocket`, `helpers/rmtestServerStep.m`): the `msocket`
  functions are replaced by an in-process version. Instead of a second MATLAB running
  `listen(server)`, every message a client sends is handled immediately by the same logic
  as `@socketserver/listen.m`, calling the real methods of the server class. The real
  `keyboardserver` and `mouseserver` are used; `helpers/@rmtestdeviceserver` is a generic
  simulated device whose samples come from a function you provide.
* **Simulated Psychtoolbox** (`stubs/psychtoolbox`): `Screen`, `KbCheck`, `GetSecs`,
  `GetMouse`, `PsychPortAudio`, ... are replaced by stubs. Time is *virtual*: `GetSecs`
  advances a little on every call and `Screen('Flip')` advances by one frame, so a
  10 second trial takes a fraction of a second and the results are reproducible.
  Key presses and mouse movements are scripted, and everything that is "drawn" is recorded:

```matlab
w = rmtestWorld;
w.keyScript = [0.5 1.0 KbName('space') 6];   % space is down from 0.5 to 1.0 s of every 6 s
w.mouseScript = [0 640 700 0; 3 50 50 0];    % [time x y button], interpolated
rmtestWorld(w);
% ... run the experiment ...
w = rmtestWorld;   % w.texts = all text drawn, w.calls = number of calls of each Screen command
```

The stubs are only put on the path by `rmtestSetup` when needed: in `'auto'` mode the real
Psychtoolbox is used if it is installed (the whole-experiment tests are then skipped,
because they need the virtual clock; use `'simulated'` to run them).

## Testing with real devices

1. Start the device servers (e.g. `runkeyboardserver`, `runmouseserver`, `runtabletserver`).
2. List them in `hardware/rmtestHardwareConfig.m`.
3. `runAllTests('hardware')`. Devices whose server is not reachable are reported as skipped.

Note: the hardware tests were written without access to the devices and have not been run
against real hardware yet.

## Adding a test

Create `suites/test_something.m`:

```matlab
function cases = test_something
cases = [];
cases = rmtestCase(cases,'what should happen',@myTest);

function myTest(info)
rmtestAssert('equal',1+1,2);
rmtestAssert('error',@() error('boom'),'boom');
```

Use `rmtestWorkDir` / `rmtestCleanup` to work in a temporary experiment directory (with a
copy of the sample stimuli) so that tests never write into the repository.

## Octave

The tests add two small compatibility shims for Octave (`compat/octave`: `fields` and an
`imread` wrapper). The toolbox itself cannot *run experiments* in Octave without the
Psychtoolbox for Octave, but everything up to and including protocol validation, and the
simulated runs, work.
