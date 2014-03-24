% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m
% This method should be overloaded by a child class if you want an
% ability to finish a trial early (say if a target has been reached)

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition)
devices = get(e,'devices');
if isfield(devices,'keyboard')
    data = getsample(devices.keyboard);
    if numel(data)>1
        keypressed = data(2);
    else
        keypressed = [];
    end
else
    [keyIsDown, secs, keyCode] = KbCheck;
    keypressed = find(keyCode);
    if isempty(keypressed)
        keypressed = -1;
    end
end
if any(keypressed == r.keytopress)
    toFinish = 1;
else
    toFinish = 0;
end
