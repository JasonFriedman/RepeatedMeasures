% vibrateTactorCommand - generate the command to vibrate the tactor(s) for a given duration
% 
% vibrateTactorCommand(tactorNumbers,duration)
% tactorNumbers  - array of tactors to vibrate (e.g. 1, [1 2], etc). First tactor is number 1
% duration - duration to vibrate, in ms

function command = vibrateTactorCommand(tactorNumbers,duration)

tactorNum = uint8(sum(2.^(tactorNumbers-1)));
theduration = uint8(duration ./10);

PacketStartByte = uint8(2);
PacketEndByte = uint8(3);
MasterBoard = uint8(0);
TacOnTimeCommand = uint8(hex2dec('11'));
DataLength2 = uint8(2);

command = withChecksum([PacketStartByte MasterBoard TacOnTimeCommand DataLength2 tactorNum theduration PacketEndByte]);
