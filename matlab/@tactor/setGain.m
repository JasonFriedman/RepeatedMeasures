% SETGAIN - set the gain (strength) of the tactor
% setGain(t,gain)
%
% gain can be 0,1,2 or 3

function setGain(t,gain)

command = setGainCommand(gain);

[nwritten,when,errmsg] = IOPort('Write',t.s,command);
pause(0.1);
readACK(t);