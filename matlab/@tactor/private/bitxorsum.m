% BITXORSUM - perform a bitwise XOR sum
% 
% xorsum = bitxorsum(data)

function xorsum = bitxorsum(data)

xorsum = bitxor(data(1),data(2));
for k=3:numel(data)
    xorsum = bitxor(xorsum,data(k));
end
