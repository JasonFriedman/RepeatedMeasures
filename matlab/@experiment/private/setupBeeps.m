% SETUPBEEPS - setup any beeps

function thistrial = setupBeeps(thistrial)

if ~isempty(thistrial.beep)
    thistrial.beeped = zeros(length(thistrial.beep),1);
    if ~iscell(thistrial.beep)
        beeptmp = thistrial.beep;
        thistrial = rmfield(thistrial,'beep');
        thistrial.beep{1} = beeptmp;
    end
else
    thistrial.beeped = [];
end

