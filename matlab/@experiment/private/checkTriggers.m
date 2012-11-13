% CHECKTRIGGERS - check if a trigger needs to be sent

function [triggerSent,frameInfo] = checkTriggers(frameInfo,triggerSent,triggerTime,triggerOffTime,thisFrameTime,blockcounter,e)

if ~triggerSent && thisFrameTime >= triggerTime
    frameInfo.triggerTime = GetSecs;
    triggerSent = 1;
    toSend = blockcounter * 2 + 1;
    writetolog(e,['Sending trigger' num2str(toSend)]);
    sendTriggers(e,1,toSend);
elseif triggerSent==1 && thisFrameTime >= triggerOffTime
    writetolog(e,'Sending trigger low (0)');
    frameInfo.triggerTimeOff = GetSecs;
    triggerSent=2;
    sendTriggers(e,0);
end
