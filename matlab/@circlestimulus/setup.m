% SETUP - Prepare a "circles" trial
% Do not call directly, will be called by runexperiment

function thistrial = setup(s,e,thistrial,experimentdata)

thistrial.circleArray = load(['stimuli/' s.circlesFilename]);

thistrial.stimuliFrames = length(thistrial.circleArray)* s.framesPerCircle;
