% HASSTARTED - check if a pedal has been pressed (using a joystick)
% Do not call directly, will be called by runexperiment

function [started,keyCode] = hasStarted(p,e,experimentdata)

notpressed = 1;
if p.joystickType==1
    [x,y,notpressed] = WinJoystickMex(0);
    
elseif p.joystickType==2
    [x,y,z,buttons] = WinJoystick8Mex(0);
    notpressed = ~buttons(p.joystickButton);
else
    error(['Unknown joystick type ' num2str(p.joystickType)]);
end

started = ~notpressed;

[keyIsDown, secs, keyCode ] = KbCheck;
