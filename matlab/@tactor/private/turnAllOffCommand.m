% turnAllOffCommand - produce the command to turn off all tactors
% 
% turnAllOffCommand

function command = turnAllOffCommand

PacketStartByte = uint8(2);
PacketEndByte = uint8(3);
MasterBoard = uint8(0);
turnAllOff = uint8(hex2dec('00'));
DataLength0 = uint8(0);

command = withChecksum([PacketStartByte MasterBoard turnAllOff DataLength0 PacketEndByte]);
