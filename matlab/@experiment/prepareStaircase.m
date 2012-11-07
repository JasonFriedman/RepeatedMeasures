% PREPARESTAIRCASE - prepare any staircases that are used (e.g. QUEST)
% They need to be in a directory called _staircase, e.g. QUESTstaircase

function experimentdata = prepareStaircase(e,experimentdata,protocol)

if isempty(e.staircases)
    return;
end

staircases = fields(e.staircases);

for k=1:length(staircases)
    eval(['experimentdata.(staircases{k}) = ' staircases{k} 'staircase(protocol)']);
end
