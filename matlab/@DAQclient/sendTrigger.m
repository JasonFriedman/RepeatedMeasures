% SENDTRIGGER - send a trigger through the DAQ

function sendTrigger(t,value)

codes = messagecodes;

m.parameters = value;
m.command = codes.DAQ_sendTrigger;
sendmessage(t,m,'sendTrigger');