% HASSTARTED - This function should check if the necessary condition has been fulfilled to start the trial
% This should not be run directly, it is called by runexperiment.m
% This version does not wait, unless a mouse button or keyboard is pressed
% (i.e. the response from the previous trial)

function [started,keyCode,thistrial] = hasStarted(s,e,experimentdata,thistrial)

% Only check the mouse if the tablet is not being used
devices = fields(get(e,'devices'));
if ~any(strcmp(devices,'tablet'))
    [x,y,buttons] = GetMouse;
    while(buttons(1))
        [x,y,buttons] = GetMouse;
    end
end

% wait for the keyboard to be released
[secs, keyCode] = KbReleaseWait;

started = 1;
