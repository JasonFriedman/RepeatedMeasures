% GETXYZ - get an xyz coordinate from the device
%
% data = getxyz(sc)

function xyz = getxyz(tc)

lastsample = getsample(tc);

if isempty(lastsample)
    xyz = [NaN NaN];
else
    xyz = lastsample(1:2);
end
