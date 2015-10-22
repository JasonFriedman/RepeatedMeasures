% GETXYZ - get the xyz coordinates of all markers

function xyz = getxyz(tc)

lastsample = getsample(tc);
nummarkers = (numel(lastsample)-1)/8;
for m=1:nummarkers
    xyz((m-1)*3+1:(m-1)*3+3) = lastsample((m-1)*8+1:(m-1)*8+3);
end
