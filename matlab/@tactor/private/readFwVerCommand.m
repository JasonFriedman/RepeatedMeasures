% readFwVerCommand - generate the command to read the firmware version
% 
% readFwVerCommand

function command = readFwVerCommand

PacketStartByte = uint8(2);
PacketEndByte = uint8(3);
MasterBoard = uint8(0);
readFwVerCommand = uint8(hex2dec('42'));
DataLength1 = uint8(0);

command = withChecksum([PacketStartByte MasterBoard readFwVerCommand DataLength1 PacketEndByte]);
