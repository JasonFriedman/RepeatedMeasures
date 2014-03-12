% playSeqCommand - generate the command to play a sequence
% 
% playSeqCommand(seqnm) - must specify the sequence number (e.g. 0)

function command = playSeqCommand(seqnum)

PacketStartByte = uint8(2);
PacketEndByte = uint8(3);
MasterBoard = uint8(0);
playSequence = uint8(hex2dec('1a'));
DataLength1 = uint8(1);
theseqnum = uint8(seqnum);

command = withChecksum([PacketStartByte MasterBoard playSequence DataLength1 theseqnum PacketEndByte]);
