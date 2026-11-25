# Synchrony in Joint Action Is Directed by Each Participant's Motor Control System

Noy L, Weiser N, Friedman J (2017). Synchrony in Joint Action Is Directed by Each Participant's Motor Control System. *Frontiers in Psychology*. https://doi.org/10.3389/fpsyg.2017.00531

## What's here

One-person mirror game on a graphics tablet (or mouse): the participant tracks 11 computer-generated stimuli. `generateProtocol(subject,inputDevice)` makes the protocol; `stimuli/dot1.csv`–`dot11.csv` are the stimuli, the same set released on figshare (see `stimuli/plotstimuliexample.m`).

- `matlab/` – the protocol generator(s) and the scripts used to run the experiment
- `stimuli/` – stimulus files referenced by the protocols (where needed)

## Running

Copy this folder somewhere, add RepeatedMeasures to the MATLAB path, `cd` into the folder (so that `protocols/` and `stimuli/` are relative to it) and call the generator from `matlab/`. The code is as it was used for the study, so device settings (ports, screen sizes, tablet ranges, sensor gains) may need changing for your setup, and it may need small changes to run on the current version of RepeatedMeasures.
