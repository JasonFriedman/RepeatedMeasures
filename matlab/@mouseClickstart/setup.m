% SETUP - Do any preparation needed for starting the trial
% Do not call directly, this will be called by runexperiment
% In general, this method should be overridden by the subclass

function thistrial = setup(s,thistrial)

% Set this to 1 so that it will start sampling (so we can know when the
% button is clicked)
thistrial.sampleWhenNotRecording = 1;