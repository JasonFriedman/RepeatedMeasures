% READFWVER - read the firmware version
% readFwVer(t)
%
% Result will be in the ACK


function readFwVer(t)

command = readFwVerCommand;

sendmessage(t,command);
pause(0.1);
readACK(t,1);