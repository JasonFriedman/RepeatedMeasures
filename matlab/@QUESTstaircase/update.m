% UPDATE - update the QUEST staircase

function q = update(q,thistrial)

if thistrial.questSuccess > -1
    qn = str2double(thistrial.quest);
    if strcmp(thistrial.stimulus,'VCRDM')
        q.q{qn} = QuestUpdate(q.q{qn},log(thistrial.coherence),thistrial.questSuccess);
    elseif strcmp(thistrial.stimulus,'images')
        q.noiseVars{qn} = [q.noiseVars{qn} thistrial.noiseVar];
        q.questSuccesses{qn} = [q.questSuccesses{qn} thistrial.questSuccess];
        q.q{qn} = QuestUpdate(q.q{qn},thistrial.tTest,thistrial.questSuccess);
    else
        error('Don''t know how to update quest for this type of stimuli');
    end
    
    % Also update q_alltrials if appropriate
    if isfield(q,'q_alltrials')
        if strcmp(thistrial.stimulus,'VCRDM')
            q.q_alltrials = QuestUpdate(q.q_alltrials{1},log(thistrial.coherence),thistrial.questSuccess);
        elseif strcmp(thistrial.stimulus,'images')
            q.q_alltrials{qn} = QuestUpdate(q.q_alltrials{qn},thistrial.tTest,thistrial.questSuccess);
        else
            error('Don''t know how to update quest for this type of stimuli');
        end
    end
end

