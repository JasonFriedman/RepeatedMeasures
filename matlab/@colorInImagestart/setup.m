% SETUP - Do any preparation needed for starting the trial
% Do not call directly, this will be called by runexperiment
% In general, this method should be overrided by the subclass

function thistrial = setup(s,thistrial)

thistrial.sampleWhenNotRecording = 1;
thistrial.startpressedTime = NaN;
