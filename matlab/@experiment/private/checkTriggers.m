% CHECKTRIGGERS - check if a trigger needs to be sent

function thistrial = checkTriggers(e,thistrial,thisFrameTime,experimentdata)

if ~isempty(thistrial.trigger)
    for k=1:numel(thistrial.trigger)
        if ~thistrial.trigger{k}.sent && thisFrameTime >= thistrial.trigger{k}.time
            thistrial.trigger{k}.senttime = GetSecs;
            thistrial.trigger{k}.sent = 1;
            value = thistrial.trigger{k}.value;
            writetolog(e,['Sending trigger' num2str(value)]);
            sendTriggers(e,experimentdata,thistrial.trigger{k}.type,1,value);
        elseif thistrial.trigger{k}.sent==1 && thisFrameTime > thistrial.trigger{k}.offTime
                writetolog(e,'Sending trigger low (0)');
                thistrial.trigger{k}.offtime = GetSecs;
                thistrial.trigger{k}.sent=2;
                sendTriggers(e,experimentdata,thistrial.trigger{k}.type,0,0);
        end
    end
end