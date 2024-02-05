% SENDTRIGGERS - send a trigger to the appropriate device
%
% sendTriggers(e,experimentdata,type,onoff,value)
function sendTriggers(e,experimentdata,type,onoff,value)

codes = messagecodes;
markEvent(e,codes.triggerSent+value);

if strcmp(type,'serial')
    sendmessage(experimentdata.serial,uint8(value));
elseif strcmp(type,'serialportserver')
    devices = get(e,'devices');
    sendTrigger(devices.serialport,uint8(value));        
elseif strcmp(type,'parallel')
    sendmessage(experimentdata.parallel,uint8(value));
elseif strcmp(type,'DAQ')
    devices = get(e,'devices');
    if isfield(devices,'forcesensors') 
        if onoff
            sendTrigger(devices.forcesensors,uint8(value));
        else
            sendTrigger(devices.forcesensors,0);
        end
    elseif isfield(devices,'DAQ')
        if onoff
            sendTrigger(devices.DAQ,uint8(value));
        else
            sendTrigger(devices.DAQ,0);
        end
    else
        if onoff
            sendTrigger(e.MCtrigger,[],uint8(value));
        else
            sendTrigger(e.MCtrigger,0);
        end
    end
elseif strcmp(type,'arduino')
    devices = get(e,'devices');
    if onoff
        sendTrigger(devices.arduino,uint8(value));
    else
        sendTrigger(devices.arduino,0);
    end
else
    error(['Unsupported trigger type: ' type]);
end