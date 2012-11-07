% QUESTstaircase - prepare a QUEST staircase

function s = QUESTstaircase(protocol)

for k=1:length(protocol.quest)
    if ~isstruct(e.protocol.quest)
        thisquest = e.protocol.quest{k};
    else
        thisquest = e.protocol.quest;
    end
    s.q{k}=QuestCreate(str2double(thisquest.tGuess),...
        str2double(thisquest.tGuessSd), ...
        str2double(thisquest.pThreshold),...
        str2double(thisquest.beta), ...
        str2double(thisquest.delta),...
        str2double(thisquest.gamma));
    s.q{k}.normalizePdf=1;
    s.q_alltrials{k} = s.q{k};
    s.questSuccesses{k} = [];
    s.noiseVars{k} = [];
end

s = class('QUESTstaircase',s);
