% HASSTARTED - has the trial started?
% Do not call directly, will be called by runexperiment

function [started,keyCode] = hasStarted(m,e,experimentdata)

lastposition = getxyz(e);

started = 0;
distance = sqrt(sum((lastposition - experimentdata.targetPosition(m.target,:)).^2));
if distance < m.threshold
    started = 1;
end

% check the keyboard also
[keyisdown,secs, keyCode ] = KbCheck;
