% PREPARESTAIRCASE - prepare any staircases that are used (e.g. QUEST)
% They need to be in a directory called _staircase, e.g. QUESTstaircase

function experimentdata = prepareStaircase(e,experimentdata,debug)

if isempty(e.staircases)
    return;
end

staircases = fields(e.staircases);

for k=1:length(staircases)
    staircaseparameters = e.protocol.setup.(staircases{k});
    eval(['experimentdata.staircases{k} = ' staircases{k} 'staircase(staircaseparameters,e,debug);']);
end
