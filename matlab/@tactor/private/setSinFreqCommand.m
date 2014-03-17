% setSinFreqCommand - set the sin frequency
%
% command = setSinFreqCommand(index,freq)
% 

function command = setSinFreqCommand(index,freq)

PacketStartByte = uint8(2);
PacketEndByte = uint8(3);
MasterBoard = uint8(0);
if index==1
    setSinFreq = uint8(hex2dec('12'));
elseif index==2
    setSinFreq = uint8(hex2dec('14'));
else
    error('index must be 1 or 2');
end

DataLength = uint8(2);
LSB = uint8(mod(freq,256));
MSB = uint8(floor(freq/256));

command = withChecksum([PacketStartByte MasterBoard setSinFreq DataLength LSB MSB PacketEndByte]);

