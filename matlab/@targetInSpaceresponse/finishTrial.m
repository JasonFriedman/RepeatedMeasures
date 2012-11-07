% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition)

lastposition = getxyz(e);
toFinish = 0;

for k=1:numel(r.targets)
    thisdistance = sqrt(sum((lastposition - experimentdata.targetPosition(r.targets(k),:)).^2));
    if thisdistance < r.threshold
        toFinish = 1;
        break;
    end
end


