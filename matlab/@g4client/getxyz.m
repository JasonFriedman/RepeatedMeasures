% GETXYZ - get the xyz coordinates of all markers

function xyz = getxyz(lc)

lastsample = getsample(lc);
for m=1:lc.numsensors
    xyz((m-1)*3+1:(m-1)*3+3) = lastsample((m-1)*6+2:(m-1)*6+4);
end
