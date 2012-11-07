% GETXYZ - get the xyz coordinates

function xyz = getxyz(lc)

lastsample = getsample(lc);
xyz = lastsample(2:4); % 1 is the framenumber
