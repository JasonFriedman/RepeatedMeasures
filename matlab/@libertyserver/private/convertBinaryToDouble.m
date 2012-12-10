% Convert a binary number (IEEE 754) represented as four integers to a double
function value = convertBinaryToDouble(result)

for n=(numel(result)/4):-1:1
    sign = bitget(result(n*4),8);
    exponent = [bitget(result(n*4-1),8) bitget(result(n*4),1:7)]*2.^(0:7)';
    fraction = [bitget(result(n*4-3),1:8) bitget(result(n*4-2),1:8) bitget(result(n*4-1),1:7)]*2.^(-23:-1)';
    value(n) = (-1)^sign*(1+fraction)*2^(exponent-127);
end