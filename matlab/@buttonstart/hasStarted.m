% HASSTARTED - check if the button has been pressed to start the trial

function [started,keyCode] = hasStarted(b,e,experimentdata)

devices = get(e,'devices');
if get(e,'MCPresent')
    started = readButton(get(e,'MCtrigger'));
elseif isfield(devices,'buttonbox')
    started = readButton(devices.buttonbox);
else
    error('No button / DAQ devices are connected');
end
[keyIsDown, secs, keyCode ] = KbCheck;
