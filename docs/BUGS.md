# RepeatedMeasures – bugs found (November 2026)

Found by reading the code, by a scan for undefined variables, by running the parameter
definitions of every class, and by running the sample experiments with simulated devices
(GNU Octave). **Fixed** = fixed on the branches `fix/code-bugs` / `fix/docs-and-comments`.
**Open** = needs your decision or the hardware; not changed.

Nothing here was run in MATLAB or with real devices: the fixes were checked in Octave with
the simulated Psychtoolbox / devices of the new test suite where the code can run there
(experiment loop, keyboard, mouse, parameter parsing, samples), and by inspection otherwise
(hardware clients / servers, VR, video).

## A. Code – fixed

| # | File | Problem |
|---|---|---|
| 1 | `@experiment/runexperiment.m` | Pressing `n` (skip trial) stored the skipped trial under the index of the *next* trial (`currentTrial` was incremented first). |
| 2 | `@experiment/runexperiment.m` | `experimentdata.noiseLevels(currentTrial) = noiseVar;` – `noiseVar` is undefined (should be `thistrial.noiseVar`); any trial with `noiseVar` crashed after the response. |
| 3 | `@experiment/runexperiment.m` | `thistrial.RT` was set *after* the trial was copied into `results.thistrial`, so `results.mat` never contained the RT per trial. |
| 4 | `@experiment/runexperiment.m` | After a crash the screen was closed but PsychPortAudio was left open. |
| 5 | `@experiment/readResources.m` | A protocol with exactly one label crashed (`labels{k}` on a struct); `beeps`, `tactorSequences` were already handled with `makecellifnot`. |
| 6 | `@experiment/private/drawTextLocation.m` | `nargin<7` should be `nargin<8` (`noflip` is the 8th argument): calling it with 7 arguments crashed. |
| 7 | `@experiment/private/DrawBackground.m` | For a white background the image number was used as the texture pointer (`thistrial.backgroundImage` instead of `experimentdata.textures(...)`, as in the other branch). |
| 8 | `@triggerstart/hasStarted.m`, `@triggerresponse/finishTrial.m`, `@targetOnScreenresponse/finishTrial.m`, `@vrstimulus/displayFrame.m` (x2) | `kbCheck` instead of `KbCheck` – an error on case-sensitive systems and in current MATLAB. |
| 9 | `@colorInImagestart/colorInImagestart.m` | Inherited from `response` instead of `start` (`parentclassname` says `start`). |
| 10 | `@colorInImageresponse/colorInImageresponse.m` | The defaults of `colorStart` and `endtime` were swapped (`colorStart` = 0, `endtime` = [0 0 0]). |
| 11 | `@colorInImageresponse/finishTrial.m` | Undefined variable `lastpositionVisual` when `showPositionFeedback` is used. |
| 12 | `@movementThresholdresponse/movementThresholdresponse.m` | The constructor had no input argument but used `inputParams`: this response could not be created at all. |
| 13 | `@pointToPointresponse/finishTrial.m` | With `rotateTablet`: undefined `lastsample` and `pressure`. |
| 14 | `@pointToPointresponse/pointToPointresponse.m` | Defaults of `start` / `end` were `[0 0]` / `[0 1]` although they are target numbers. |
| 15 | `@showdataresponse/showPositionCommon.m`, `showdataresponse.m` | `lastPositionVisual` vs `lastpositionVisual`, a 4-D index into a 3-D array, defaults of the range matrices were cell arrays. (`frame` is still undefined in the `showPosition==4` branch – see C3.) |
| 16 | `@socketclient/showPositionCommon.m` | Two-row `showPositionColor` used the undefined `lastsample(4)`; now uses `thistrial.pressure`. |
| 17 | `@socketclient/socketclient.m` | The check of a custom `showPositionType` (`'@function'`) indexed the cell array instead of its element. |
| 18 | `@keyboardserver/keyboardserver.m` | `nargin<5` with 3 arguments: the `debug` argument was always ignored. |
| 19 | `@mouseEntersBoxresponse/feedback.m` | `isnan(dataSummary)` on a struct is an error in MATLAB; replaced by `~isstruct`. |
| 20 | `@mouseEntersBoxresponse/finishTrial.m` | Since commit `acb0ef4` the mouse position came from `showPosition`: without `showPosition` the trial never ended, with it the y axis was mirrored. With a mouse the mouse is sampled directly again (the path for other devices is unchanged). |
| 21 | `@glovetrackerclient/close.m` | Used the undefined `gfc` instead of the argument `sc`. |
| 22 | `@tactor/setSigSrc.m` | Called the non-existent `sendcommand` (should be `sendmessage`). |
| 23 | `@videostimulus/displayFrame.m`, `videostimulus.m` | Undefined `windowPtr` and `screenInfo`; the error message added `.avi` to the file name. |
| 24 | `@rectanglestimulus/rectanglestimulus.m` | Checked that `stimuli/<rectanglesFilename>` exists before checking whether a file name was given at all. |
| 25 | `@calibrateForceSensorsstimulus/displayFrame.m` | Looked for `ATIforcesensors` in `experimentdata` instead of in the devices, so the sensors were never zeroed. |
| 26 | `@staircase/staircase.m` | `s.debug` was set and then overwritten by `readParameters`. |
| 27 | `@fingerOppositionSequenceresponse/finishTrial.m` | Missing semicolon printed the sequence position on every key press. |
| 28 | `readParameters.m` | Inside lists, "zero or more" parameters (`required=2`) were treated as required. |
| 29 | `makeProtocolDocumentation.m` | `printf(fp,...)` instead of `fprintf` (crash for numeric defaults of nested parameters). |
| 30 | all generic `get.m` (62 files) | `eval(['result = h.' field])` → `h.(field)`: same behaviour, also works in Octave. |
| 31 | `sampleexperiments/matlab/generateMaleFemale{,Button,Opto}Protocol.m` | With 2 repetitions the file names repeated: the generators fail their own validation ("Repeated filenames") and data would be overwritten. |
| 32 | `sampleexperiments/matlab/generateCopyShapesProtocol.m` | Instruction trials lacked `recording = 0`, so the generator fails validation ("Must specify a filename when recording"). |

## B. Comments and documentation – fixed

* `docs/protocolDocumentation` was out of date with the code and is regenerated;
  `response_fingerOppositionsequence.html` had a different case from the generated name.
* Parameter descriptions: `trigger.type` did not list `serialportserver`;
  `calibrationWeight` said `calibrationType=1` (it is 2); pointToPoint `start`/`end`
  referred to `setup.positions` (it is `setup.targetPosition`); `textArray` had the class
  description `'Draw '`; unbalanced brackets in the QUEST descriptions.
* "If the background is not white, then draw it" – the code tests for *black* (3 places).
* `drawText.m` help did not list `textColor`, `swapDirection`; `experiment.m` help did not
  mention `resultDir`.
* Spelling in comments, log and error messages ("Succesful", "These is no class",
  "Weibell", "seperate", "recieve", "occured", ...).
* README: "Windows (XP or 7)".

## C. Open – needs your decision

1. **Committed sample protocols are stale.** 10 of the 19 files in
   `sampleexperiments/protocols` are rejected by the current validation: `CopyShapes`,
   `MaleFemale`, `MaleFemaleButton`, `MaleFemaleOpto` (regenerate after fixes 31–32),
   `NCE`, `RDK`, `TMSTrigger` (`optotrak.markers` no longer exists), `QuestImages` (no
   recording device), `MaskedPriming` (stimuli matrix has the old shape),
   `SequenceLearning` (missing `stimuli/sequence41324.png`). Regenerate or delete them.
2. `@mouseEntersBoxresponse/finishTrial.m` sets `thistrial.targetNum = hitTarget`, so the
   feedback (`hitTarget == targetNum`) can never say "missed". Probably should not
   overwrite `targetNum`.
3. `@movementThresholdresponse/feedback.m` uses `triggerTime`, `stimuliFrames`,
   `separateMarkers`, `targetPosition` which are never defined; `@showdataresponse`
   uses an undefined `frame`. They look like unfinished / legacy code: fix or remove.
4. `messagecodes.m`: event codes overlap. `targetOn` and `triggerReceived` are both 1000;
   `triggerSent + value` (20–275) overlaps the DRT codes (60–62), audioStroop (70–77) and
   `imageState` (100+). Changing them would break existing analysis code.
5. `@characterclient` is found as a device by `experiment.m` (any `@*client` directory)
   but takes 2 arguments and is not a `socketclient`: `setup.character` would crash.
6. `@experiment/experiment.m`: `e.quest = isfield(e.protocol,'quest')` is always false
   (only `setup`, `trial`, `common` are allowed).
7. `runexperiment.m`: audioStroop recordings are written with a fixed 44100 Hz rather than
   `experimentdata.freq`; the `catch` swallows the error (prints only the top of the stack).
8. `redamber` protocols in your Dropbox use `showPositionType = 'none'`, which
   `socketclient` rejects unless the client overrides the check – worth a look.
9. `matlab/msocket` has no `mexmaca64` binary: on Apple-silicon MATLAB (R2023b+ native)
   the clients cannot connect until msocket is recompiled.
10. `@socketserver` has no `set.m`; servers whose `runcommand` returns changed parameters
    each define their own (fine today, fragile for new servers).
