% GETDATALENGTH - get the length of a single frame of data
%
% datalength = getdatalength(mb,numberofmarkers)
%
% For the fastrak, a single frame is always of size 6; 3 coordinate position values and 3 angles 
% (plus time stamp plus event stamp)

function datalength = getdatalength(fts,numberofmarkers)

no_of_receivers = get(fts, 'receivers');
datalength = (no_of_receivers *6) + 2;
