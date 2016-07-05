% HASSTARTED - has the trial started?
% Do not call directly, will be called by runexperiment

function [started,keyCode,thistrial] = hasStarted(m,e,experimentdata,thistrial)

devices = get(e,'devices');
if isfield(devices,'mouse')
    lastsample = getsample(devices.mouse);
else
    [x,y,buttons] = GetMouse;
    lastsample(1) = x ./ experimentdata.screenInfo.screenRect(3);
    lastsample(2) = y ./ experimentdata.screenInfo.screenRect(4);
    lastsample(3) = buttons(1);
end

started = 0;
if numel(lastsample)>1
    x = lastsample(1)*experimentdata.screenInfo.screenRect(3);
    y = (1-lastsample(2))*experimentdata.screenInfo.screenRect(4);
    clicked = lastsample(3);
    
    if clicked
        if isempty(m.targets)
            started = 1;
            fprintf('Started on mouse click (with no targets)\n');
        else
            for k=1:length(m.targets)
                %fprintf('%.2f, %.2f vs %.2f,%.2f,%.2f,%.2f\n',x,y,experimentdata.mouseTargets(m.targets(k),1),...
                %        experimentdata.mouseTargets(m.targets(k),2),experimentdata.mouseTargets(m.targets(k),3),experimentdata.mouseTargets(m.targets(k),4));
                if x>=experimentdata.mouseTargets(m.targets(k),1) && x<=experimentdata.mouseTargets(m.targets(k),1) + experimentdata.mouseTargets(m.targets(k),3) ...
                        && y>=experimentdata.mouseTargets(m.targets(k),2) && y<=experimentdata.mouseTargets(m.targets(k),2) + experimentdata.mouseTargets(m.targets(k),4)
                    started = 1;
                end
            end
        end
    end
end

% check the keyboard also
[keyisdown,secs, keyCode ] = KbCheck(-1);
