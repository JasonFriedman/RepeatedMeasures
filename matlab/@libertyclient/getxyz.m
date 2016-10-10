% GETXYZ - get the xyz coordinates of all markers

function xyz = getxyz(lc)

lastsample = getsample(lc);

if lc.recordOrientation
    for m=1:lc.numsensors
        xyz((m-1)*3+1:(m-1)*3+3) = lastsample((m-1)*6+2:(m-1)*6+4);
    end
else
    xyz = lastsample(2:lc.numsensors*3+1); 
end
