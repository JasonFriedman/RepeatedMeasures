% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition,frame)

lastposition = getxyz(e);
toFinish = 0;
waiting = 0;

for k=1:numel(r.targets)
    if isnan(r.dimensionsToUse)
        thisdistance = sqrt(sum((lastposition - experimentdata.targetPosition(r.targets(k),:)).^2));
    else
        if size(r.dimensionsToUse,1)>1
            calculated = sum(r.dimensionsToUse .* lastposition,2)';
        else
            calculated = lastposition(r.dimensionsToUse);
        end
        %lastposition
        %[calculated experimentdata.targetPosition(r.targets(k),:)]
        thisdistance = sqrt(sum((calculated - experimentdata.targetPosition(r.targets(k),:)).^2));
    end
    
    if thisdistance < r.threshold
        if r.endtime==0 
            thistrial.pressedLocation = r.targets(k);
            thistrial.pressedTime = GetSecs;
            toFinish = 1;
        else
            if isnan(thistrial.pressedTime)
                thistrial.pressedTime = GetSecs;
                thistrial.pressedLocation = r.targets(k);
                waiting=1;
            elseif r.targets(k)==thistrial.pressedLocation && GetSecs - thistrial.pressedTime >= r.endtime
                toFinish = 1;
            elseif r.targets(k)==thistrial.pressedLocation && GetSecs - thistrial.pressedTime < r.endtime
                waiting = 1;
            end
        end
        break;
    end
end
if toFinish==0 && waiting==0
    thistrial.pressedLocation = NaN;
    thistrial.pressedTime = NaN;
end

[keyIsDown, secs, keycode] = KbCheck(-1);
if ~isempty(find(keycode,1)) && (find(keycode,1)==KbName('q') || find(keycode,1)==KbName('n'))
    toFinish = true;
end

