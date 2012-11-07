% GETDATALENGTH - get the length of a single frame of data
%
% datalength = getdatalength(s,numberofmarkers)

function datalength = getdatalength(s,numberofmarkers)

% each frame has the sampled time, one bit for each marker, and an event indicator
datalength = numberofmarkers + 2;
