% TURNOFFALLTACTORS - turn off all tactors
%
% turnOffAllTactors(t)

function turnOffAllTactors(t)

command = turnAllOffCommand;

sendmessage(t,command);
pause(0.1);
readACK(t);