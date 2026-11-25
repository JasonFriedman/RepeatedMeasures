# Offline Optimization of the Relative Timing of Movements in a Sequence Is Blocked by Retroactive Behavioral Interference

Friedman J, Korman M (2016). Offline Optimization of the Relative Timing of Movements in a Sequence Is Blocked by Retroactive Behavioral Interference. *Frontiers in Human Neuroscience*. https://doi.org/10.3389/fnhum.2016.00623

## What's here

Finger-opposition sequence task recorded with a Polhemus Liberty (6 sensors). `generateProtocol.m` builds the protocol for each session (1–3); `runexperimentSession1–3.m` run them.

- `matlab/` – the protocol generator(s) and the scripts used to run the experiment
- `stimuli/` – stimulus files referenced by the protocols (where needed)

**Source / notes:** From the `fingerlearning2` project.

## Running

Copy this folder somewhere, add RepeatedMeasures to the MATLAB path, `cd` into the folder (so that `protocols/` and `stimuli/` are relative to it) and call the generator from `matlab/`. The code is as it was used for the study, so device settings (ports, screen sizes, tablet ranges, sensor gains) may need changing for your setup, and it may need small changes to run on the current version of RepeatedMeasures.
