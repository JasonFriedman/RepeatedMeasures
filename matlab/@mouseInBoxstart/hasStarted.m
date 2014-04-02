% HASSTARTED - has the trial started?
% Do not call directly, will be called by runexperiment

function [started,keyCode] = hasStarted(m,e,experimentdata)

devices = get(e,'devices');
lastsample = getsample(devices.mouse);

started = 0;
if numel(lastsample)>1
    x = lastsample(1)*experimentdata.screenInfo.screenRect(3);
    y = (1-lastsample(2))*experimentdata.screenInfo.screenRect(4);
    for k=1:length(m.targets)
        if x>=experimentdata.mouseTargets(m.targets(k),1) && x<=experimentdata.mouseTargets(m.targets(k),1) + experimentdata.mouseTargets(m.targets(k),3) ...
                && y>=experimentdata.mouseTargets(m.targets(k),2) && y<=experimentdata.mouseTargets(m.targets(k),2) + experimentdata.mouseTargets(m.targets(k),4)
            started = 1;
        end
    end
end

% check the keyboard also
[keyisdown,secs, keyCode ] = KbCheck;
