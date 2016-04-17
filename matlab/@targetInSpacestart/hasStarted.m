% HASSTARTED - has the trial started?
% Do not call directly, will be called by runexperiment

function [started,keyCode] = hasStarted(m,e,experimentdata,thistrial)

d = get(e,'devices');
if isfield(d,'tablet')
    [lastposition,~,pressure] = getsampleVisual(d.tablet,thistrial,-1);
    lastposition = lastposition(1:2);
else
    lastposition = getxyz(e);
    pressure = 1; % only relevant for tablet
end

% if isfield(thistrial,'rotatedposition') && ~isempty(thistrial.rotatedposition)
%     clear lastposition;
%     lastposition(:,1:2) = thistrial.rotatedposition;
%     lastposition(:,2) = 1-lastposition(:,2);
%     % Use the first sensor
%     lastposition = lastposition(1,:);
% end

started = 0;
if size(experimentdata.targetPosition,1)<m.target
    error('Not enough targets defined: %d are defined, need to be at least %d',size(experimentdata.targetPosition,1),m.target);
end
if isnan(m.dimensionsToUse(1))
    distance = sqrt(sum((lastposition - experimentdata.targetPosition(m.target,:)).^2));
else
    distance = sqrt(sum((lastposition(m.dimensionsToUse) - experimentdata.targetPosition(m.target,:)).^2));
end
if isnan(lastposition(1))
    started = NaN;
    writetolog(e,'Can''t yet decide if has started, returning NaN');
elseif distance < m.threshold && (~m.touching || pressure>0)
    started = 1;
    writetolog(e,['started=1, x=' num2str(lastposition(1))]);
end

% check the keyboard also
[keyisdown,secs, keyCode ] = KbCheck;
