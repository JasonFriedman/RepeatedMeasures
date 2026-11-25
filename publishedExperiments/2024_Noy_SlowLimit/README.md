# A slow limit: extensive motor training cannot overcome a limit on the production of slow and smooth motion

Noy L, van der Wel R, Friedman J (2024). A slow limit: extensive motor training cannot overcome a limit on the production of slow and smooth motion. *Journal of Neurophysiology*. https://doi.org/10.1152/jn.00208.2024

## What's here

Mirror-game tracking of slow stimuli on a tablet (red target ellipse, blue cursor ellipse), with an upside-down monitor and a transfer condition. `generateProtocol(subject,inputDevice,version,flipped,stimuli)` makes the protocol; `runExperimentTabletFlipped.m` (training) and `runExperimentTabletFlippedTransfer.m` (transfer) run it. Stimuli are in `stimuli/`.

- `matlab/` – the protocol generator(s) and the scripts used to run the experiment
- `stimuli/` – stimulus files referenced by the protocols (where needed)

**Source / notes:** From the `slowLearning` project.

## Running

Copy this folder somewhere, add RepeatedMeasures to the MATLAB path, `cd` into the folder (so that `protocols/` and `stimuli/` are relative to it) and call the generator from `matlab/`. The code is as it was used for the study, so device settings (ports, screen sizes, tablet ranges, sensor gains) may need changing for your setup, and it may need small changes to run on the current version of RepeatedMeasures.
