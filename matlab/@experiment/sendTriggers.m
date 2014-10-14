function sendTriggers(e,experimentdata,type,onoff,value)

if strcmp(type,'serial')
    sendmessage(experimentdata.serial,uint8(value));
else
    error(['Unsupported trigger type: ' type]);
end