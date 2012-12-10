% GETDATALENGTH - get the length of a single frame of data
%
% datalength = getdatalength(s,numberofmarkers)
%
% For the cyberglove, a single frame is always of size 23 
% (plus time stamp plus event stamp)

function datalength = getdatalength(s,numberofmarkers)

datalength = 23 + 2;
