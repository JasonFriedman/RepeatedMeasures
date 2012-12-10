% GETDATALENGTH - get the length of a single frame of data
%
% datalength = getdatalength(s,numberofmarkers)

function datalength = getdatalength(s,numberofmarkers)

% each frame has 3D data for each marker, plus a frame number, and an event indicator
datalength = numberofmarkers * 3 + 2;
