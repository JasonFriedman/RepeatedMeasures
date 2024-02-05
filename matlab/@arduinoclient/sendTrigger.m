% SENDTRIGGER - send a trigger through the arduino

function sendTrigger(t,value)

codes = messagecodes;

m.parameters = value;
m.command = codes.ARDUINO_sendTrigger;
sendmessage(t,m,'sendTrigger');