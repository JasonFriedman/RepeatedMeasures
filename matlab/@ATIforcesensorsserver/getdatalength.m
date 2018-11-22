% GETDATALENGTH - get the length of a single frame of data
%
% datalength = getdatalength(s,numberofmarkers)

function datalength = getdatalength(s,numberofmarkers)

% each frame has the 6 values, time, and an event indicator
datalength = numberofmarkers * 7 + 1 ;
