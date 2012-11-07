% WHICHTARGETHIT - which target was hit by the mouse (if any)

function hitTarget = whichTargetHit(r,lastlocation,experimentdata)

hitTarget = 0;
for k=r.targets
    if lastlocation(1) >= experimentdata.mouseTargets(k,1) && ...
            lastlocation(1) <= experimentdata.mouseTargets(k,1) + experimentdata.mouseTargets(k,3) && ...
            lastlocation(2) >= experimentdata.mouseTargets(k,2) && ...
            lastlocation(2) <= experimentdata.mouseTargets(k,2) + experimentdata.mouseTargets(k,3)
        hitTarget = k;
    end
end
