% HASSTARTED - has the trial started?
% Do not call directly, will be called by runexperiment

function [started,keyCode] = hasStarted(m,e,experimentdata,thistrial)

d = get(e,'devices');
if isfield(d,'tablet')
    lastposition = getsampleVisual(d.tablet,thistrial);
    lastposition = lastposition(1:2);
    tmp = getsample(d.tablet);
    pressure = tmp(4);
else
    lastposition = getxyz(e);
    pressure = 1; % only relevant for tablet
end
if isfield(thistrial,'rotatedposition')
    lastposition(1:2) = thistrial.rotatedposition;
    lastposition(2) = 1-lastposition(2);
end

started = 0;
if size(experimentdata.targetPosition,1)<m.target
    error('Not enough targets defined: %d are defined, need to be at least %d',size(experimentdata.targetPosition,1),m.target);
end
distance = sqrt(sum((lastposition - experimentdata.targetPosition(m.target,:)).^2));
if distance < m.threshold && (~m.touching || pressure>0)
    started = 1;
end

% check the keyboard also
[keyisdown,secs, keyCode ] = KbCheck;
