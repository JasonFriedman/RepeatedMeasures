% setTactorsCommand - generate the command to specify which tactors to use (usually as part of a sequence)
% 
% command = setTactorsCommand(tactorNumbers)
% tactorNumbers  - array of tactors to vibrate (e.g. 1, [1 2], etc). First tactor is number 1

function command = setTactorsCommand(tactorNumber)

tactorNum = uint8(sum(2.^(tactorNumber-1)));

PacketStartByte = uint8(2);
PacketEndByte = uint8(3);
MasterBoard = uint8(0);
setTactorsCommand = uint8(hex2dec('80'));
DataLength1 = uint8(1);

command = withChecksum([PacketStartByte MasterBoard setTactorsCommand DataLength1 tactorNum PacketEndByte]);
