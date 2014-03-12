% seqDataCommand - produce the commands to send sequence data
%
% This will return a cell array, the commands in the cells should be sent one after the other
% 
% commands = seqDataCommand(seqdata)

function commands = seqDataCommand(seqdata)

for k=1:ceil(numel(seqdata)/56)
    inds = (k*56)-55:min([k*56 numel(seqdata)]);
    thisdata = seqdata(inds);

    PacketStartByte = uint8(2);
    PacketEndByte = uint8(3);
    MasterBoard = uint8(0);
    seqData = uint8(hex2dec('1c'));
    DataLength = uint8(numel(thisdata));
    
    commands{k} = withChecksum([PacketStartByte MasterBoard seqData DataLength thisdata PacketEndByte]);
end
