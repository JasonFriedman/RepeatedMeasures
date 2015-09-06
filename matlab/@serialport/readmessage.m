% READMESSAGE - read a message from the serial port
% result = readmessage(s)

function result = readmessage(s,amount)

if nargin<2
    result = IOPort('Read',s.s);
else
    result = IOPort('Read',s.s,1,amount);
end