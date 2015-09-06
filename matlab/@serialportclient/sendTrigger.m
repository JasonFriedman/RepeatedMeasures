% SENDTRIGGER - send a trigger via the serialport
function sendTrigger(s,value)

codes = messagecodes;

m.command = codes.SERIALPORT_sendTrigger;
m.parameters = value;

sendmessage(s,m,'SendTrigger');
