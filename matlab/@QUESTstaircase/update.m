% UPDATE - update the QUEST staircase. The stimulus must be a supported type

function q = update(q,thistrial)

if thistrial.questSuccess > -1
    if isa(thistrial.thisstimulus,'VCRDMstimulus')
        q.q = QuestUpdate(q.q,log(thistrial.coherence),thistrial.questSuccess);
    elseif isa(thistrial.thisstimulus,'imagesstimulus') || isa(thistrial.thisstimulus,'rectanglestimulus') || isa(thistrial.thisstimulus,'linestimulus')
        q.tTests = [q.tTests thistrial.tTest];
        q.questSuccesses = [q.questSuccesses thistrial.questSuccess];
        q.q = QuestUpdate(q.q,thistrial.tTest,thistrial.questSuccess);
    else
        thistrial.thisstimulus
        error('Don''t know how to update quest for this type of stimuli:');
    end
    
    % Also update q_alltrials if appropriate
    if isfield(q,'q_alltrials')
        if isa(thistrial.thisstimulus,'VCRDMstimulus')
            q.q_alltrials = QuestUpdate(q.q_alltrials,log(thistrial.coherence),thistrial.questSuccess);
        elseif isa(thistrial.thisstimulus,'imagesstimulus') || isa(thistrial.thisstimulus,'rectanglestimulus') || isa(thistrial.thisstimulus,'linestimulus')
            q.q_alltrials = QuestUpdate(q.q_alltrials,thistrial.tTest,thistrial.questSuccess);
        else
            thistrial.thisstimulus
            error('Don''t know how to update quest for this type of stimuli');
        end
    end
end

