% GETDATALENGTH - get the length of a single frame of data
%
% datalength = getdatalength(l,numberofmarkers)

function datalength = getdatalength(l,numberofmarkers)

% each frame has x,y,z coordinates, 3 orientations, an event indicator and a timestamp
datalength = numberofmarkers * 6+ 3;
