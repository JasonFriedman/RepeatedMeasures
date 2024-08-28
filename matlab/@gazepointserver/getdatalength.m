% GETDATALENGTH - get the length of a single frame of data
%
% datalength = getdatalength(k,numberofmarkers)

function datalength = getdatalength(k,numberofmarkers)

% each frame has the x,y,time (from the eye tracker), time (from the computer) and marker
datalength = 5;
