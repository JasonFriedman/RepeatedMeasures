# Moving objects by imagination? Amount of finger movement and pendulum length determine success in the Chevreul pendulum illusion

Cantergi D, Awasthi B, Friedman J (2021). Moving objects by imagination? Amount of finger movement and pendulum length determine success in the Chevreul pendulum illusion. *Human Movement Science*. https://doi.org/10.1016/j.humov.2021.102879

## What's here

Pendulum and upper-limb movement recorded with a Polhemus Liberty (8 sensors). `generateProtocol(subjectNum)` makes the protocol; `runexperiment.m` runs it.

- `matlab/` – the protocol generator(s) and the scripts used to run the experiment
- `stimuli/` – stimulus files referenced by the protocols (where needed)

**Source / notes:** From `otherArticles/chevreul2`.

## Running

Copy this folder somewhere, add RepeatedMeasures to the MATLAB path, `cd` into the folder (so that `protocols/` and `stimuli/` are relative to it) and call the generator from `matlab/`. The code is as it was used for the study, so device settings (ports, screen sizes, tablet ranges, sensor gains) may need changing for your setup, and it may need small changes to run on the current version of RepeatedMeasures.
