% SETUP - Prepare a "rectangles" trial
% Do not call directly, will be called by runexperiment

function thistrial = setup(s,e,thistrial,experimentdata)

thistrial.rectangleArray = load(['stimuli/' s.rectanglesFilename]);

thistrial.stimuliFrames = length(thistrial.rectangleArray)* s.framesPerRectangle;
