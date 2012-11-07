% UPDATESTAIRCASE - update any staircases that are used (e.g. QUEST)

function experimentdata = updateStaircase(e,experimentdata,thistrial)

if isempty(e.staircases)
    return;
end

staircases = fields(e.staircases);

for k=1:length(staircases)
    experimentdata.(staircases{k}) = update(experimentdata.(staircases{k}),thistrial);
end
