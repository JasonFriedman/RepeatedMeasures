% PLAYSEQUENCE - play a sequence of vibration events
% These must have been already defined earlier using defineSequence
% playSequence(t,sequenceNum)
%

function playSequence(t,sequenceNum)

sendmessage(t,playSeqCommand(sequenceNum));
pause(0.01);
readACK(t);