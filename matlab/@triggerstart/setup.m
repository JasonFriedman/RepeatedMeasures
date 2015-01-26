% SETUP - Do any preparation needed for starting the trial
% Do not call directly, this will be called by runexperiment
% In general, this method should be overrided by the subclass

function thistrial = setup(s,thistrial)

% Set this to 1 so that it will start samping (so we can know when the trigger is sent)
thistrial.sampleWhenNotRecording = 1;