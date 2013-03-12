% GETXYZ - get an xyz coordinate from the device
%
% data = getxyz(sc)

function xyz = getxyz(tc)

lastsample = getsample(tc);
xyz = lastsample(1:2);
