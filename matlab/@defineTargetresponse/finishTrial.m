% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m
%
% For defineTargetResponse, the trial ends when the space bar is pressed

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition)

toFinish = 0;

[keyIsDown, secs, keyCode] = KbCheck;

if ~isempty(find(keyCode,1)) && find(keyCode,1)==KbName('space')
    toFinish = 1;
    experimentdata.targetPosition(r.targetNum,:) = getxyz(e);
end

