% SETUP - Prepare a "rectangles" trial
% Do not call directly, will be called by runexperiment

function thistrial = setup(s,e,thistrial,experimentdata)

if ~isempty(s.rectangles)
    thistrial.rectangleArray = s.rectangles;
else
    thistrial.rectangleArray = load(['stimuli/' s.rectanglesFilename]);
end

if size(thistrial.rectangleArray,2) ~=5
    error('The width of the rectangle array for the rectangle stimulus must be 5');
end

thistrial.stimuliFrames = length(thistrial.rectangleArray)* s.framesPerRectangle;

% If a staircase is being used, replace NaN values with the staircase value
if ~isnan(thistrial.staircaseNum)
    thistrial.tTest = getStaircaseValue(experimentdata.staircases{thistrial.staircaseNum});
    % Replace all values of NaN with the value from the staircase
    thistrial.rectangleArray(isnan(thistrial.rectangleArray)) = thistrial.tTest;
end
