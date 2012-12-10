% GETDATALENGTH - get the length of a single frame of data
%
% datalength = getdatalength(k,numberofmarkers)

function datalength = getdatalength(k,numberofmarkers)

% each frame has the time, key pressed  and an event indicator
datalength = 3;
