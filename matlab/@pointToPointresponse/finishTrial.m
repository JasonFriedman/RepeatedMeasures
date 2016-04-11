% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m
% This method should be overloaded by a child class if you want an
% ability to finish a trial early (say if a target has been reached)

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition,frame)

toFinish = false;
[maxx,maxy] = getmaxxy(e);

if isfield(thistrial,'rotatedposition')
    lastsample(1:2) = thistrial.rotatedposition;
    lastsample(2) = 1-lastsample(2);
    lastposition = lastsample(1:2) .* [maxx maxy];
elseif isempty(lastposition)
    m = get(e,'devices');
    if isfield(m,'tablet')
        [lastsample,~,pressure] = getsampleVisual(m.tablet,thistrial,frame);
    else
        lastsample = getxyz(e);
        pressure = 1; % i.e. ignore
    end
    lastposition = lastsample(1:2) .* [maxx maxy];
else
    pressure = thistrial.pressure;
end

% movement stages:
% -1: has not started
% 0 : has touched start point
% 1: has crossed mid line
% 2: has reached finish point (but potentially waiting)
% 3: has reached finish point and finished waiting
% (then it returns to -1)

if ~isempty(lastposition)
    % If not touching, restart the trial
    if pressure==0
        thistrial.movementStage = -1;
    elseif thistrial.movementStage == -1;
        if sqrt(sum((lastposition - experimentdata.targetPosition(r.start,:).*[maxx maxy]).^2)) <= (r.startDistance * maxx)
            thistrial.movementStage = 0;
        end
    elseif thistrial.movementStage == 0
        startendvector = experimentdata.targetPosition(r.end,:).*[maxx maxy] - experimentdata.targetPosition(r.start,:) .* [maxx maxy];
        startenddistance = sqrt(sum(startendvector.^2));
        startcurrentpoint = lastposition - experimentdata.targetPosition(r.start,:).*[maxx maxy];
        startenddirection = startendvector ./ sqrt(sum(startendvector.^2));
        projection_along_startend = dot(startcurrentpoint,startenddirection);
        if projection_along_startend > 0.5*startenddistance
            thistrial.movementStage = 1;
        end
    elseif thistrial.movementStage == 1
        if sqrt(sum((lastposition - experimentdata.targetPosition(r.end,:).*[maxx maxy]).^2)) <= (r.endDistance * maxx)
            thistrial.movementStage = 2;
            thistrial.reachedStage2 = GetSecs;
        end
    end
end

if thistrial.movementStage == 2
    if sqrt(sum((lastposition - experimentdata.targetPosition(r.end,:).*[maxx maxy]).^2)) > (r.endDistance * maxx)
        thistrial.movementStage = 1;
    elseif r.endtime <= (GetSecs-thistrial.reachedStage2)
        thistrial.movementStage = 3;
    end
    % Otherwise wait in stage2 until enough time has passed
end

if thistrial.movementStage == 3
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

[keyIsDown, secs, keycode] = KbCheck;
if ~isempty(find(keycode,1)) && (find(keycode,1)==KbName('q') || find(keycode,1)==KbName('n'))
    toFinish = true;
end
