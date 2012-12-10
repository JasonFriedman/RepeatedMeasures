% FEEDBACK - Provide feedback for moving mouse into target on the screen
% This should not be run directly, it is called by runexperiment.m

function thistrial = feedback(r,e,thistrial,previoustrial,experimentdata,dataSummary)

hitTarget = whichTargetHit(r,dataSummary.lastlocation,experimentdata);

% Hit the screen, but not a target
if hitTarget == 0
    thistrial.successful=-2;
    thistrial.questSuccess = -1;
    writetolog(e,'Hit screen but no target');
    thistrial.responseText = experimentdata.texts.MISSED_TARGET;
    thistrial.textFeedback = 1; % We always display this feedback
    thistrial.playsound = 1;
elseif isnan(thistrial.targetNum(1))
    % there is no correct target specified
    thistrial.successful = NaN;
    thistrial.questSuccess = -1;
    writetolog(e,'Hit a target but no correct target defined in protocol');
    thistrial.textFeedback = 0;
    thistrial.playsound = 0;
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
