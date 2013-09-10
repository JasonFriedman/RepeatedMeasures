% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m
%
% For defineTargetResponse, the trial ends when the space bar is released (after being pressed)

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition)

toFinish = 0;

[keyIsDown, secs, keyCode] = KbCheck;

if isfield(thistrial,'pressedKey') && isempty(find(keyCode,1))
    toFinish=1;
end

if ~isfield(thistrial,'pressedKey') && ~isempty(find(keyCode,1)) && find(keyCode,1)==KbName('space')
    if size(experimentdata.targetPosition,1)>=r.targetNum && ~all(experimentdata.targetPosition(r.targetNum,:)==0)
        experimentdata.targetPositionOld(r.targetNum,:) = experimentdata.targetPosition(r.targetNum,:);
    end
    experimentdata.targetPosition(r.targetNum,:) = getxyz(e);
    % Don't finish the trial yet, rather when the key is released
    thistrial.pressedKey = 1;
end

