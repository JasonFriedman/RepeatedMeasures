% FEEDBACK - Provide feedback for reaching target on the screen
% This should not be run directly, it is called by runexperiment.m

function thistrial = feedback(r,e,thistrial,previoustrial,experimentdata,dataSummary,results)

% Check if they were moving forward most of the time
if r.checkGoingForward && isfield(dataSummary,'goingforwardratio') && all(dataSummary.goingforwardratio < 0.8)
    thistrial.successful = -1;
    thistrial.responseText = 'Not moving forward enough';
    thistrial.playsound = 1;
    thistrial.questSuccess = -1;
elseif r.checkFixation && isfield(dataSummary,'fixationok') && ~dataSummary.fixationok
    fprintf('Not fixating enough\n');
    thistrial.successful = -1;
    thistrial.responseText = 'Not fixating on the dot enough!!!';
    thistrial.playsound = 1;
    thistrial.questSuccess = -1;
    thistrial.textFeedback = 1;
else
    hitTarget = thistrial.pressedLocation;
    
    if hitTarget == thistrial.targetNum
        thistrial.successful=1;
        thistrial.questSuccess = 1;
        writetolog(e,['Succesful to target ' num2str(hitTarget)]);
        thistrial.responseText = experimentdata.texts.SUCCESS;
    elseif hitTarget>0
        thistrial.successful=0;
        thistrial.questSuccess = 0;
        writetolog(e,['Moved to wrong target ' num2str(hitTarget)]);
        thistrial.responseText = experimentdata.texts.WRONG;
    else %no target was reached
        thistrial.questSuccess = -1;
        thistrial.successful = -3;
        writetolog(e,'Did not hit any target');
        thistrial.playsound = 1;
        % We always want feedback in this case (unless textFeedback is set
        % to -1)
        if thistrial.textFeedback~=-1
            thistrial.textFeedback = 1;
        end
        thistrial.responseText = experimentdata.texts.NEITHER_TARGET;
    end
    
    if r.delayedFeedback && ~isempty(previoustrial)
        % Show the feedback from the previous trial
        thistrial.responseText = previoustrial.responseText;
        writetolog(e,['Set response text to text from previous trial: ' previoustrial.responseText]);
        thistrial.textFeedback = 1;
    end
    
    if isfield(thistrial,'targetFeedback') && isfield(thistrial.targetFeedback,'text')
        thistrial.textFeedback = 1;
    end
    
    % If we are giving feedback on arrival time
    if ~isnan(r.arrivalFeedbackStart)
        arrivaltime = thistrial.pressedTime - thistrial.frameInfo.startFrame(1);
        if arrivaltime < r.arrivalFeedbackStart
            thistrial.successful = -3;
            thistrial.questSuccess = -1;
            writetolog(e,'Arrived at target too early');
            thistrial.responseText = experimentdata.texts.TARGET_TOO_EARLY;
            if thistrial.textFeedback == 0
                thistrial.textFeedback = 1;
            end
            if thistrial.auditoryFeedback
                thistrial.playsound = 1;
            end
        end
    end
    if ~isnan(r.arrivalFeedbackEnd)
        arrivaltime = thistrial.pressedTime - thistrial.frameInfo.startFrame(1);
        if arrivaltime > r.arrivalFeedbackEnd
            thistrial.successful = -3;
            thistrial.questSuccess = -1;
            writetolog(e,'Arrived at target too late');
            thistrial.responseText = experimentdata.texts.TARGET_TOO_LATE;
            if thistrial.textFeedback == 0
                thistrial.textFeedback = 1;
            end
            if thistrial.auditoryFeedback
                thistrial.playsound = 1;
            end
        end
    end
end
