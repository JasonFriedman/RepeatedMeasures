function sendTriggers(e,experimentdata,type,onoff,value)

if strcmp(type,'serial')
    sendmessage(experimentdata.serial,uint8(value));
elseif strcmp(type,'parallel')
    sendmessage(experimentdata.parallel,uint8(value));
elseif strcmp(type,'DAQ')
    if onoff
        sendTrigger(e.MCtrigger,[],uint8(customDataValue));
    else
        sendTrigger(e.MCtrigger,0);
    end
else
    error(['Unsupported trigger type: ' type]);
end