% GETDATALENGTH - get the length of a single frame of data
%
% datalength = getdatalength(t,numberofmarkers)

function datalength = getdatalength(ts,numberofmarkers)

% each sensor has x,y,z coordinates + 3 Euler angles + quality + time stamp
datalength = numberofmarkers * 8 + 1;