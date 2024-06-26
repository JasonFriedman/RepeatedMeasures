% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition,frame)

if nargin<5
    m = get(e,'devices');
    lastsample = getsample(m.mouse);
    lastposition(1) = lastsample(1) * experimentdata.screenInfo.screenRect(3);
    lastposition(2) = (1-lastsample(2)) * experimentdata.screenInfo.screenRect(4);
else
    if numel(lastposition)>0
        % convert to pixels - for nonmouse devices
        lastposition(1) = lastposition(1) * experimentdata.screenInfo.screenRect(3);
        lastposition(2) = (1-lastposition(2)) * experimentdata.screenInfo.screenRect(4);
    end
end

hitTarget = whichTargetHit(r,lastposition,experimentdata);

toFinish = (hitTarget>0);
if toFinish
    thistrial.targetNum = hitTarget;
end

[keyIsDown, secs, keycode] = KbCheck;
if ~isempty(find(keycode,1)) && (find(keycode,1)==KbName('q') || find(keycode,1)==KbName('n'))
    toFinish = true;
end

