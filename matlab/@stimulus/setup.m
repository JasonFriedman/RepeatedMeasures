% SETUP - Prepare a trial. This is any preparation that needs to be done at the start of a trial.
% Do not call directly, this will be called by runexperiment
% In general, this method should be overrided by the subclass

function thistrial = setup(s,e,thistrial,experimentdata)

thistrial.stimuliFrames = 1;