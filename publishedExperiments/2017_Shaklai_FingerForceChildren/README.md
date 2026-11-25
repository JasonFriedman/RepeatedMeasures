# Development of finger force coordination in children

Shaklai S, Mimouni-Bloch A, Levin M, Friedman J (2017). Development of finger force coordination in children. *Experimental Brain Research*. https://doi.org/10.1007/s00221-017-5093-2

## What's here

Finger-force recording with PCB force sensors. `generateMVCProtocol.m` makes the maximal-voluntary-contraction protocol and `generateProtocol.m` the main pressing task; `runMVC.m` / `runExperiment.m` run them, and `calculateMVC.m` computes the MVC used to scale the task. `stimuli/` holds the images shown to the children.

- `matlab/` – the protocol generator(s) and the scripts used to run the experiment
- `stimuli/` – stimulus files referenced by the protocols (where needed)

**Source / notes:** From the `UCM_children` project.

## Running

Copy this folder somewhere, add RepeatedMeasures to the MATLAB path, `cd` into the folder (so that `protocols/` and `stimuli/` are relative to it) and call the generator from `matlab/`. The code is as it was used for the study, so device settings (ports, screen sizes, tablet ranges, sensor gains) may need changing for your setup, and it may need small changes to run on the current version of RepeatedMeasures.
