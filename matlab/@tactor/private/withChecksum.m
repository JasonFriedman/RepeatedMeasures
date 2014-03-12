% WITHCHECKSUM - include the checksum in the command (in the second last value)
% result = withChecksum(withoutChecksum)

function result = withChecksum(withoutChecksum)

checksum = bitxorsum([withoutChecksum(1:end-1) hex2dec('EA') withoutChecksum(end)]);
result = [withoutChecksum(1:end-1) checksum withoutChecksum(end)];