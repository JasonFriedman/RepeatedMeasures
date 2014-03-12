% seqStartCommand - sequence end command
% 
% command = seqEndCommand(seqnum,sequenceLength)
% must specify the sequence number (e.g. 0) and the length

function command = seqStartCommand(seqnum,sequenceLength)

PacketStartByte = uint8(2);
PacketEndByte = uint8(3);
MasterBoard = uint8(0);
seqStart = uint8(hex2dec('1B'));
DataLength4 = uint8(4);
theseqnum = uint8(seqnum);

sequenceLength1 = mod(sequenceLength,2^8);
sequenceLength = floor(sequenceLength./2^8);
sequenceLength2 = mod(sequenceLength,2^8);
sequenceLength = floor(sequenceLength./2^8);
sequenceLength3 = mod(sequenceLength,2^8);

command = withChecksum([PacketStartByte MasterBoard seqStart DataLength4 theseqnum sequenceLength1 sequenceLength2 sequenceLength3 PacketEndByte]);
