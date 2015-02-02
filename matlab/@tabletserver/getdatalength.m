% GETDATALENGTH - get the length of a single frame of data
%
% datalength = getdatalength(k,numberofmarkers)

function datalength = getdatalength(k,numberofmarkers)

% each frame has 5+1 values (x,y,z,pressure) + timestamp + GetSecs ( + marker)
datalength = 7;
