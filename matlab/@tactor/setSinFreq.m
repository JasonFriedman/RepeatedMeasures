% SETSINFREQ - set the gain (strength) of the tactor
% setSinFreq(index,frequency)
%
% index can be 1 or 2
% frequency is in Hz

function setSinFreq(t,index,frequency)

command = setSinFreqCommand(index,frequency);

[nwritten,when,errmsg] = IOPort('Write',t.s,command);
pause(0.1);
readACK(t);