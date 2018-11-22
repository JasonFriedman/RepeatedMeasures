% GETDATALENGTH - get the length of a single frame of data
%
% datalength = getdatalength(l,numberofmarkers)

function datalength = getdatalength(l,numberofmarkers)

% each frame has a quaternion (4), orientations (3), 3 time stamps (2 from the device, one from the system), then for all markers: an event indicator and a timestamp
datalength = numberofmarkers * 8 + 3;
