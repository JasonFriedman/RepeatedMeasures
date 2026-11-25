# Corrective jitter motion shows similar individual frequencies for the arm and the finger

Noy L, Alon U, Friedman J (2015). Corrective jitter motion shows similar individual frequencies for the arm and the finger. *Experimental Brain Research*. https://doi.org/10.1007/s00221-015-4204-1

## What's here

Tracking of 11 pseudo-random stimuli, once with the arm (tablet stylus) and once with the index finger (Polhemus Liberty). `runexperimentTabletFirst.m` / `runexperimentLibertyFirst.m` call `generateProtocol(5,[],subject,inputDevice)` (protocolType 5 = tracking; 3 = tablet, 4 = Liberty). `generateRectangles*.m` / `generatePseudorandom.m` made the stimulus files in `stimuli/`.

- `matlab/` – the protocol generator(s) and the scripts used to run the experiment
- `stimuli/` – stimulus files referenced by the protocols (where needed)

**Source / notes:** From the `forceMirrorGame` project. `generateProtocol.m` also contains force-sensor protocols (MVC, force ramp) that were not part of this paper. `generateProtocol2.m` is a later, simpler variant of the tracking protocol from the same project.

## Running

Copy this folder somewhere, add RepeatedMeasures to the MATLAB path, `cd` into the folder (so that `protocols/` and `stimuli/` are relative to it) and call the generator from `matlab/`. The code is as it was used for the study, so device settings (ports, screen sizes, tablet ranges, sensor gains) may need changing for your setup, and it may need small changes to run on the current version of RepeatedMeasures.
