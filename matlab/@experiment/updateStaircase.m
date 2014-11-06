% UPDATESTAIRCASE - update any staircases that are used (e.g. QUEST)

function experimentdata = updateStaircase(e,experimentdata,thistrial)

if isempty(experimentdata.staircases)
    return;
end

if isnan(thistrial.staircaseNum)
    return;
end

experimentdata.staircases{thistrial.staircaseNum} = update(experimentdata.staircases{thistrial.staircaseNum},thistrial);
