% GETSAMPLE - get the latest sample of data
% [data,framenumber] = getsample(o,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(d,nummarkers)

% Get the latest data from the DAQ card
if d.numInput>0
    data = read(d.dq);
else
    data = [];
end

% These is no timing information returned, so use getSecs 
framenumber = GetSecs;

data = double(data);
data(1) = framenumber;