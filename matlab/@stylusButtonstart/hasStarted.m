% HASSTARTED - check if the button on the stylus has been pressed (when using a WACOM tablet)
% Do not call directly, will be called by runexperiment

function [started,keyCode] = hasStarted(s,e,experimentdata,thistrial)

devices = get(e,'devices');

if ~isfield(devices,'tablet')
    error('Tablet recording must be present to use the stylus button to start events');
end
buttons = getbuttons(devices.tablet);
% 1 = pressure > 0 = bitget(buttons,1)
% 2 = side button (lower) = bitget(buttons,2)
% 4 = side button (upper) = bitget(buttons,3)

started = 0;
if ~isempty(buttons) && (bitget(buttons,2) || bitget(buttons,3))
    started = 1;
end
[keyIsDown, secs, keyCode ] = KbCheck(-1);
