% SETUP - Prepare a "circles" trial
% Do not call directly, will be called by runexperiment

function thistrial = setup(s,e,thistrial,experimentdata)

if ~isempty(s.circlesFilename)
    thistrial.circleArray = load(['stimuli/' s.circlesFilename]);
else
    thistrial.circleArray = s.circleLocations;
end

thistrial.stimuliFrames = length(thistrial.circleArray)* s.framesPerCircle;
