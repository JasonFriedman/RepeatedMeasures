% HASSTARTED - has the trial started?
% Do not call directly, will be called by runexperiment

function [started,keyCode] = hasStarted(m,e,experimentdata,thistrial)

d = get(e,'devices');
if isfield(d,'tablet')
    lastposition = getsampleVisual(d.tablet,thistrial);
    lastposition = lastposition(1:2);
else
    lastposition = getxyz(e);
end
if isfield(thistrial,'rotatedposition')
    lastposition(1:2) = thistrial.rotatedposition;
    lastposition(2) = 1-lastposition(2);
end

started = 0;
distance = sqrt(sum((lastposition - experimentdata.targetPosition(m.target,:)).^2));
if distance < m.threshold
    started = 1;
end

% check the keyboard also
[keyisdown,secs, keyCode ] = KbCheck;
