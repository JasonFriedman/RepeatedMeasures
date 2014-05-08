% seqGainCommand - set the gain
%
% Possible values are 0,1,2 or 3
% 
% commands = seqGainCommand(seqdata)

function command = setGainCommand(gain)

PacketStartByte = uint8(2);
PacketEndByte = uint8(3);
MasterBoard = uint8(0);
setGain = uint8(hex2dec('20'));
DataLength = uint8(1);

if gain==0
    gainVal = uint8(hex2dec('0'));
elseif gain==1
    gainVal = uint8(hex2dec('40'));
elseif gain==2
    gainVal = uint8(hex2dec('80'));
elseif gain==3
    gainVal = uint8(hex2dec('c0'));
else
    error('gain must be 0,1,2 or 3');
end

command = withChecksum([PacketStartByte MasterBoard setGain DataLength gainVal PacketEndByte]);

