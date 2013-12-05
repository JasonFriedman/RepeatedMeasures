% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition)

toFinish = 0;
[x,y,buttons] = GetMouse;
if buttons(1)
    thistrial.pressedLocation = [x y];
    thistrial.pressedTime = GetSecs;
    toFinish = 1;
end

[keyIsDown, secs, keycode] = KbCheck;
if ~isempty(find(keycode,1)) && (find(keycode,1)==KbName('q') || find(keycode,1)==KbName('n'))
    toFinish = true;
end

