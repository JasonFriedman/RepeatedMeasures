% SETUPTACTORS - setup any tactors

function thistrial = setupTactors(thistrial)

if ~isempty(thistrial.tactor)
    thistrial.tactored = zeros(numel(thistrial.tactor),1);
    if ~iscell(thistrial.tactor)
        tactorTmp = thistrial.tactor;
        thistrial = rmfield(thistrial,'tactor');
        thistrial.tactor{1} = tactorTmp;
    end
else
    thistrial.tactored = [];
end

