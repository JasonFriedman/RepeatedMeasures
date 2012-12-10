% FEEDBACK - Provide feedback for reaching target on the screen
% This should not be run directly, it is called by runexperiment.m

function thistrial = feedback(r,e,thistrial,previoustrial,experimentdata,dataSummary)

% Check if they were moving forward most of the time
if r.checkGoingForward && isfield(dataSummary,'goingforwardratio') && all(dataSummary.goingforwardratio < 0.8)
    thistrial.successful = -1;
    thistrial.responseText = 'Not moving forward enough';
    thistrial.playsound = 1;
    thistrial.questSuccess = -1;
else
    hitTarget = -1;
    for k=1:numel(r.targets)
        thisdistance = sqrt(sum((dataSummary.meanfinalposition - experimentdata.targetPosition(r.targets(k),:)).^2));
        if thisdistance < r.threshold
            hitTarget = r.targets(k);
            break;
        end
    end
    
    if hitTarget == thistrial.targetNum
        thistrial.successful=1;
        thistrial.questSuccess = 1;
        writetolog(e,['Succesful to target' num2str(hitTarget)]);
        thistrial.responseText = experimentdata.texts.SUCCESS;
    elseif hitTarget>0
        thistrial.successful=0;
        thistrial.questSuccess = 0;
        writetolog(e,['Moved to wrong target' num2str(hitTarget)]);
        thistrial.responseText = experimentdata.texts.WRONG;
    else %no target was reached
        thistrial.questSuccess = -1;
        thistrial.successful = -3;
        writetolog(e,'Did not hit any target');
        thistrial.playsound = 1;
        % We always want feedback in this case
        thistrial.textFeedback = 1;
        thistrial.responseText = experimentdata.texts.NEITHER_TARGET;
    end
    
    if r.delayedFeedback && ~isempty(previoustrial)
        % Show the feedback from the previous trial
        thistrial.responseText = previoustrial.responseText;
    end
    
    if isfield(thistrial,'targetFeedback') && isfield(thistrial.targetFeedback,'text')
        thistrial.textFeedback = 1;
    end
    
    % If we are giving feedback on arrival time
    if isfield(thistrial,'arrivalFeedback')
        arrivaltime = thistrial.pressedTime - frameInfo{currentTrial}.startFrame(1);
        if arrivaltime > str2double(thistrial.arrivalFeedback.cutofftime)
            thistrial.successful = -3;
            thistrial.questSuccess = -1;
            writetolog(e,'Arrived at target too late');
            thistrial.responseText = experimentdata.texts.TARGET_TOO_LATE;
            thistrial.playsound = 1;
            if isfield(thistrial.arrivalFeedback,'text')
                thistrial.textFeedback = 1;
            end
        else
            % do nothing
        end
    end
end
