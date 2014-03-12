% setWaitCommand - generate the command to specify how long to wait (as part of a sequence)
% 
% command setWaitCommand(waitTime)
% waittime is in ms

function command = seqWaitCommand(waitTime)

PacketStartByte = uint8(2);
PacketEndByte = uint8(3);
MasterBoard = uint8(0);
setWait = uint8(hex2dec('1F'));
DataLength2 = uint8(2);
waitTimeLSB = mod(waitTime,256);
waitTimeMSB = floor(waitTime / 256);

command = withChecksum([PacketStartByte MasterBoard setWait DataLength2 waitTimeLSB waitTimeMSB PacketEndByte]);
