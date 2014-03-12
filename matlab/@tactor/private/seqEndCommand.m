% seqEndCommand - sequence end command
% 
% command = seqEndCommand(seqdata) 
%
% must specify the data (not including sequenceStartCommand)

function command = seqEndCommand(seqdata)

PacketStartByte = uint8(2);
PacketEndByte = uint8(3);
MasterBoard = uint8(0);
seqEnd = uint8(hex2dec('1D'));
DataLength1 = uint8(1);
checksum = bitxorsum(seqdata);

command = withChecksum([PacketStartByte MasterBoard seqEnd DataLength1 checksum PacketEndByte]);
