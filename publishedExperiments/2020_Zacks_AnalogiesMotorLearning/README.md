# Analogies can speed up the motor learning process

Zacks O, Friedman J (2020). Analogies can speed up the motor learning process. *Scientific Reports*. https://doi.org/10.1038/s41598-020-63999-1

## What's here

Two tablet tasks, each in its own subfolder: `mirrorGame/` (tracking; `generateProtocol.m`, run with `runExperimentTabletFlipped.m`) and `pointToPoint/` (sequential pointing, `generateProtocol(part)` with part = pre / training / post, run with `runExperiment.m`).

- `matlab/` – the protocol generator(s) and the scripts used to run the experiment
- `stimuli/` – stimulus files referenced by the protocols (where needed)

**Source / notes:** From `otherArticles/Oryan`. The mirror-game generator is a variant of the one in `2024_Noy_SlowLimit`.

## Running

Copy this folder somewhere, add RepeatedMeasures to the MATLAB path, `cd` into the folder (so that `protocols/` and `stimuli/` are relative to it) and call the generator from `matlab/`. The code is as it was used for the study, so device settings (ports, screen sizes, tablet ranges, sensor gains) may need changing for your setup, and it may need small changes to run on the current version of RepeatedMeasures.
