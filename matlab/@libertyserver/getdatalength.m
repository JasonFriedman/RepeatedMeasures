% GETDATALENGTH - get the length of a single frame of data
%
% datalength = getdatalength(l,numberofmarkers)

function datalength = getdatalength(l,numberofmarkers)

if l.recordOrientation
    datalength = 6;
else
    datalength = 3;
end
% each frame has x,y,z coordinates an event indicator and a timestamp
% if recording orientation, there is also the 3 orientations
datalength = numberofmarkers * datalength + 3;
% frame number + data + time + markers
