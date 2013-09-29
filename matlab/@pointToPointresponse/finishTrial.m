% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m
% This method should be overloaded by a child class if you want an
% ability to finish a trial early (say if a target has been reached)

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition)
toFinish = false;

m = get(e,'devices');
if isfield(m,'tablet')
    lastsample = getsample(m.tablet);
else
    lastsample = getxyz(e);
    lastsample(4) = 1;
end

[maxx,maxy] = getmaxxy(e);

% movement stages:
% -1: has not started
% 0 : has touched start point
% 1: has crossed mid line
% 2: has reached finish point
% (then it returns to -1)

% lastsample(4) is the pressure (must be greater than 0)
if ~isempty(lastsample)
    % If not touching, restart the trial
    if lastsample(4)==0
        thistrial.movementStage = -1;
    elseif thistrial.movementStage == -1;
        if sqrt(sum((lastsample(1:2).*[maxx maxy] - experimentdata.targetPosition(r.start,:).*[maxx maxy]).^2)) <= r.startDistance
            thistrial.movementStage = 0;
        end
    elseif thistrial.movementStage == 0
        startendvector = experimentdata.targetPosition(r.end,:) - experimentdata.targetPosition(r.start,:);
        startenddistance = sqrt(sum(startendvector.^2));
        startcurrentpoint = lastsample(1:2) - experimentdata.targetPosition(r.start,:);
        startenddirection = startendvector ./ sqrt(sum(startendvector.^2));
        projection_along_startend = dot(startcurrentpoint,startenddirection);
        if projection_along_startend > 0.5*startenddistance
            thistrial.movementStage = 1;
        end
    elseif thistrial.movementStage == 1
        if sqrt(sum((lastsample(1:2).*[maxx maxy] - experimentdata.targetPosition(r.end,:).*[maxx maxy]).^2)) <= r.endDistance
            thistrial.movementStage = 2;
        end
    end
end

if thistrial.movementStage == 2
    thistrial.completedMovements = thistrial.completedMovements + 1;
    fprintf('Completed %d of %d repetitions\n',thistrial.completedMovements,r.repetitions);
    if r.beep
        beep;
    end
    thistrial.movementStage = -1;
end

if thistrial.completedMovements >= r.repetitions
    toFinish = true;
end
%thetext = sprintf('(%.2f,%.2f) = %d, N=%d',lastsample(1),lastsample(2),thistrial.movementStage,thistrial.completedMovements);
%drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,thetext,1);

[keyIsDown, secs, keycode] = KbCheck;
if ~isempty(find(keycode,1)) && find(keycode,1)==KbName('q')
    toFinish = true;
end
