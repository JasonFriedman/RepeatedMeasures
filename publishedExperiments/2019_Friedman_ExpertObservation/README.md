# Observation of an expert model induces a skilled movement coordination pattern in a single session of intermittent practice

Friedman J, Korman M (2019). Observation of an expert model induces a skilled movement coordination pattern in a single session of intermittent practice. *Scientific Reports*. https://doi.org/10.1038/s41598-019-40924-9

## What's here

Sequential pointing on a tablet, with training by observing an expert (video) or a control (random dots). `generateProtocol(group,part,triggerType,...)` makes the protocols; `runExperiment.m` runs the session. `makeBouncingDot*.m` / `makeRandomLines*.m` made the control stimuli, and `stimuli/` holds the target images, dot files and demonstration videos.

- `matlab/` – the protocol generator(s) and the scripts used to run the experiment
- `stimuli/` – stimulus files referenced by the protocols (where needed)

**Source / notes:** From the `coarticulation` project.

## Running

Copy this folder somewhere, add RepeatedMeasures to the MATLAB path, `cd` into the folder (so that `protocols/` and `stimuli/` are relative to it) and call the generator from `matlab/`. The code is as it was used for the study, so device settings (ports, screen sizes, tablet ranges, sensor gains) may need changing for your setup, and it may need small changes to run on the current version of RepeatedMeasures.
