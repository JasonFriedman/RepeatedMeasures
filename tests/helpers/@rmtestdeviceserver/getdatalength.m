% GETDATALENGTH - number of columns: the data, the time and the marker
function datalength = getdatalength(d,numberofmarkers) %#ok<INUSD>
datalength = numel(d.sampleFcn(0)) + 2;
