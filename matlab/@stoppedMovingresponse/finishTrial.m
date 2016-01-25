% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m
function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition,frame)
toFinish = false;

m = get(e,'devices');
if isfield(m,'tablet')
    lastsample = getsample(m.tablet);
else
    lastsample = getxyz(e);
end

if ~isnan(lastsample(1))
    lastsample = lastsample(1:2); % only consider x/y
    if isnan(thistrial.startMovementLocation(1)) && (isnan(r.startState) || thistrial.imageState==r.startState)
        thistrial.startMovementLocation = lastsample;
        %fprintf('Start movement location set to:\n');
        %thistrial.startMovementLocation
        %mod(GetSecs(),1000)
    end
    
    if thistrial.movementStage==-1 && sqrt(sum((lastsample - thistrial.startMovementLocation).^2)) >= r.startDistance
        thistrial.movementStage = 0;
        %fprintf('Movement started! Last sample is \n');
        %lastsample
        %mod(GetSecs(),1000)
    end
    
    if thistrial.movementStage==0 && sqrt(sum((lastsample - thistrial.previouslocation).^2)) <= r.endDistance
        thistrial.movementStage = 1;
        thistrial.startedStopping = GetSecs();
        %fprintf('Movement stopped, starting to wait\n');
        %mod(GetSecs(),1000)
    end
    
    if thistrial.movementStage==1
        if sqrt(sum((lastsample - thistrial.previouslocation).^2)) > r.endDistance
            thistrial.movementStage = 0;
            %   fprintf('Started moving again\n');
        else
            if GetSecs() - thistrial.startedStopping >= r.duration
                thistrial.movementStage = 2;
                toFinish = true;
                %      fprintf('Movement finished\n');
            else
                %     fprintf('Still stopped, waiting for time to pass: %.2f\n',mod(GetSecs(),1000));
            end
        end
    end
    thistrial.previouslocation = lastsample;
end

[keyIsDown, secs, keycode] = KbCheck;
if ~isempty(find(keycode,1)) && (find(keycode,1)==KbName('q') || find(keycode,1)==KbName('n'))
    toFinish = true;
end
