% GETDATALENGTH - get the length of a single frame of data
%
% datalength = getdatalength(k,numberofmarkers)

function datalength = getdatalength(k,numberofmarkers)

% each frame has n values data + marker 
datalength = numberofmarkers + 1;
