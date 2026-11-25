# Submovements in manual tracking: people with Parkinson's disease produce more submovements than age-matched controls

Noy L, Hassin-Baer S, Fay-Karmon T, Kattouf N, Israeli-Korn S, van der Wel R, Friedman J (2025). Submovements in manual tracking: people with Parkinson's disease produce more submovements than age-matched controls. *Journal of NeuroEngineering and Rehabilitation*. https://doi.org/10.1186/s12984-025-01592-1

## What's here

Tracking (mirror game) on a Wacom Cintiq 27QHD. `generateProtocol(subject,inputDevice,version,flipped,stimuli)` makes the protocol; `runExperimentTablet.m` runs it. Stimuli are `stimuli/dot*.csv` (plus `_flipped` versions generated for an upside-down monitor).

- `matlab/` – the protocol generator(s) and the scripts used to run the experiment
- `stimuli/` – stimulus files referenced by the protocols (where needed)

**Source / notes:** From the `mirrorGameParkinson` project. `stimuli/` also holds images for the point-to-point and smilies tasks recorded in the same sessions but not reported in this paper.

## Running

Copy this folder somewhere, add RepeatedMeasures to the MATLAB path, `cd` into the folder (so that `protocols/` and `stimuli/` are relative to it) and call the generator from `matlab/`. The code is as it was used for the study, so device settings (ports, screen sizes, tablet ranges, sensor gains) may need changing for your setup, and it may need small changes to run on the current version of RepeatedMeasures.
