% GETXYZ - get the xyz coordinates of all markers

function xyz = getxyz(lc)

lastsample = getsample(lc);
xyz = lastsample(2:lc.numsensors*3+1); 
