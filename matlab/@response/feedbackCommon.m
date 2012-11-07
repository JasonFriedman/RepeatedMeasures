% FEEDBACKCOMMON - provide feedback for button press / keyboard

function thistrial = feedbackCommon(r,e,thistrial,RT,firstpressed,LEFT,RIGHT,experimentdata)

if firstpressed == LEFT
    hitTarget = 1;
elseif firstpressed == RIGHT
    hitTarget = 2;
else
    hitTarget = 0;
end
if RT<0
    thistrial.successful = -5;
    thistrial.questSuccess = -1;
    thistrial.playsound = 1;
    writetolog(e,'Too early');
    thistrial.responseText = experimentdata.texts.TOO_EARLY;
elseif hitTarget == 0
    thistrial.successful = -4;
    thistrial.questSuccess = -1;
    thistrial.playsound = 1;
    writetolog(e,'No button pressed');
    thistrial.responseText = experimentdata.texts.TOO_SLOW;
elseif hitTarget == thistrial.targetNum
    thistrial.successful=1;
    thistrial.questSuccess = 1;
    writetolog(e,['Succesful to target' num2str(hitTarget)]);
    thistrial.responseText = experimentdata.texts.SUCCESS;
else
    thistrial.successful = 0;
    thistrial.questSuccess = 0;
    writetolog(e,['Wrong direction (correct = ' num2str(thistrial.targetNum)]);
    thistrial.responseText = experimentdata.texts.WRONG;
end
