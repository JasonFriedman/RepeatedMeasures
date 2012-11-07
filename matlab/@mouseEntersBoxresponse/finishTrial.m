% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition)

if nargin<5
    m = get(e,'devices');
    lastsample = getsample(m.mouse);
    lastposition(1) = lastsample(1) * experimentdata.screenInfo.screenRect(3);
    lastposition(2) = (1-lastsample(2)) * experimentdata.screenInfo.screenRect(4);
end

hitTarget = whichTargetHit(r,lastposition,experimentdata);

toFinish = (hitTarget>0);
