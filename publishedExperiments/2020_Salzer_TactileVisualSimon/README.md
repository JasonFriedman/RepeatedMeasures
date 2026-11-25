# Reaching trajectories unravel modality-dependent temporal dynamics of the automatic process in the Simon task: a model-based approach

Salzer Y, Friedman J (2020). Reaching trajectories unravel modality-dependent temporal dynamics of the automatic process in the Simon task: a model-based approach. *Psychological Research*. https://doi.org/10.1007/s00426-019-01177-3

## What's here

Simon task with reaching movements recorded by a Polhemus Liberty, using tactile (tactors) or visual stimuli. `generateProtocol(subjectNum,useKeyboard,useTactors)` makes the protocol; `runExperimentTactile.m` / `runExperimentVisual.m` run it.

- `matlab/` – the protocol generator(s) and the scripts used to run the experiment
- `stimuli/` – stimulus files referenced by the protocols (where needed)

## Running

Copy this folder somewhere, add RepeatedMeasures to the MATLAB path, `cd` into the folder (so that `protocols/` and `stimuli/` are relative to it) and call the generator from `matlab/`. The code is as it was used for the study, so device settings (ports, screen sizes, tablet ranges, sensor gains) may need changing for your setup, and it may need small changes to run on the current version of RepeatedMeasures.
