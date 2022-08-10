% FEEDBACK - Provide feedback for reaching target on the screen
% This should not be run directly, it is called by runexperiment.m

function thistrial = feedback(r,e,thistrial,previoustrial,experimentdata,dataSummary,results)

% Check if they were moving forward most of the time
if r.checkGoingForward && isfield(dataSummary,'goingforwardratio') && all(dataSummary.goingforwardratio < 0.8)
    thistrial.successful = -1;
    thistrial.responseText = 'Not moving forward enough';
    thistrial.playsound = 1;
    thistrial.questSuccess = -1;
elseif isfield(thistrial,'pressedLocation')
    hitTarget = 0;
    for k=1:size(experimentdata.mouseTargets,1)
        if thistrial.pressedLocation(1) >= experimentdata.mouseTargets(k,1) && ...
                thistrial.pressedLocation(1) <= experimentdata.mouseTargets(k,1) + experimentdata.mouseTargets(k,3) && ...
                thistrial.pressedLocation(2) >= experimentdata.mouseTargets(k,2) &&  ...
                thistrial.pressedLocation(2) <= experimentdata.mouseTargets(k,2) + experimentdata.mouseTargets(k,4)
            hitTarget = k;
        end
    end
    
    % Hit the screen, but not a target
    if hitTarget == 0
        thistrial.successful=-2;
        thistrial.questSuccess = -1;
        writetolog(e,'Hit screen but no target');
        thistrial.responseText = experimentdata.texts.MISSED_TARGET;
        if thistrial.textFeedback ~=-1
            thistrial.textFeedback = 1; % We always to display this feedback (if textFeedback doesn't equal -1)
        end
        thistrial.playsound = 1;
    elseif hitTarget == thistrial.targetNum
        thistrial.successful=1;
        thistrial.questSuccess = 1;
        writetolog(e,['Succesful to target' num2str(hitTarget)]);
        thistrial.responseText = experimentdata.texts.SUCCESS;
    else
        thistrial.successful=0;
        thistrial.questSuccess = 0;
        writetolog(e,['Moved to wrong target' num2str(hitTarget)]);
        thistrial.responseText = experimentdata.texts.WRONG;
    end
    
    if r.delayedFeedback && ~isempty(previoustrial)
        % Show the feedback from the previous trial
        thistrial.responseText = previoustrial.responseText;
    end
    
    
    if isfield(thistrial,'targetFeedback') && isfield(thistrial.targetFeedback,'text')
        thistrial.textFeedback = 1;
    end
    
    if thistrial.successful==0
        if isfield(thistrial,'incorrectTargetFeedback')
            if isfield(thistrial.incorrectTargetFeedback,'text')
                thistrial.textFeedback = 1;
            end
            if isfield(thistrial.incorrectTargetFeedback,'sound')
                thistrial.playsound = 1;
                thistrial.auditoryFeedback = 1;
            end
        end
    end
    
    
    % If we are giving feedback on arrival time
    if isfield(thistrial,'arrivalFeedback')
        arrivaltime = thistrial.pressedTime - thistrial.frameInfo.startFrame(1);
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
else
    thistrial.questSuccess = -1;
    thistrial.successful = -3;
    writetolog(e,'Did not hit any target');
    thistrial.playsound = 1;
    % We always want feedback in this case
    thistrial.textFeedback = 1;
    thistrial.responseText = experimentdata.texts.NEITHER_TARGET;
end
