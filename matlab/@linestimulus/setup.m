% SETUP - Prepare a "line" trial
% Do not call directly, will be called by runexperiment

function thistrial = setup(s,e,thistrial,experimentdata)

if ~isempty(s.lines)
    thistrial.lineArray = s.lines;
else
    thistrial.lineArray = load(['stimuli/' s.linesFilename]);
end

if size(thistrial.lineArray,2) ~=6
    error('The width of the line array for the line stimulus must be 6');
end

thistrial.stimuliFrames = length(thistrial.lineArray)* s.framesPerLine;

% If a staircase is being used, replace NaN values with the staircase value
if ~isnan(thistrial.staircaseNum)
    thistrial.tTest = getStaircaseValue(experimentdata.staircases{thistrial.staircaseNum});
    % Replace all values of NaN with the value from the staircase
    thistrial.lineArray(isnan(thistrial.lineArray)) = thistrial.tTest;
end
