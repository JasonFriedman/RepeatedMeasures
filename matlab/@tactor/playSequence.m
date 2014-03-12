% PLAYSEQUENCE - play a sequence of vibration events
% These must have been already defined earlier using defineSequence
% playSequence(t,sequenceNum)
%

function playSequence(t,sequenceNum)

[nwritten,when,errmsg] = IOPort('Write',t.s,playSeqCommand(sequenceNum));
pause(0.5);
readACK(t);