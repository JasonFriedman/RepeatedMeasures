% SETGAIN - set the gain (strength) of the tactor
% setGain(t,gain)
%
% gain can be 0,1,2 or 3

function setGain(t,gain)

command = setGainCommand(gain);

sendmessage(t,command);
pause(0.1);
readACK(t);