% GETDATALENGTH - get the length of a single frame of data
%
% datalength = getdatalength(k,numberofmarkers)

function datalength = getdatalength(k,numberofmarkers)

% each frame has the x,y, the buttons, the time and a marker
% this can vary from system to system, so call "GetMouse" to find
% the size
[x,y,buttons] = GetMouse;
datalength = length(buttons) + 4;
