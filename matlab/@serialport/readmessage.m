% READMESSAGE - read a message from the serial port
% result = readmessage(s)

function result = readmessage(s)

result = IOPort('Read',s.s);