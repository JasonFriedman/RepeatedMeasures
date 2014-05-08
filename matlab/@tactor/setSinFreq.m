% SETSINFREQ - set the frequency of one of the sine wave. 
% Which sine wave to use (or both) is set in setSigSrc
%
% setSinFreq(index,frequency)
%
% index can be 1 or 2
% frequency is in Hz

function setSinFreq(t,index,frequency)

command = setSinFreqCommand(index,frequency);

sendmessage(t,command);
pause(0.1);
readACK(t);