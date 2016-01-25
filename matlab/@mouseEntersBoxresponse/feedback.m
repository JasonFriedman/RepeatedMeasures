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
    if thistrial.textFeedback~=-1
        thistrial.textFeedback = 1; % We always display this feedback (unless textFeedback is -1)
    end
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
    writetolog(e,['Succesful to target ' num2str(hitTarget)]);
    thistrial.responseText = experimentdata.texts.SUCCESS;
else
    thistrial.successful=0;
    thistrial.questSuccess = 0;
    writetolog(e,['Moved to wrong target ' num2str(hitTarget)]);
    thistrial.responseText = experimentdata.texts.WRONG;
end

if r.delayedFeedback && ~isempty(previoustrial)
    % Show the feedback from the previous trial
    thistrial.responseText = previoustrial.responseText;
    writetolog(e,['Set response text to text from previous trial: ' previoustrial.responseText]);
    thistrial.textFeedback = 1;
end