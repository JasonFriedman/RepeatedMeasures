% GETSAMPLE - get the latest sample of data
% [data,framenumber] = getsample(o,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(d,nummarkers)

% Get the latest data from the DAQ card
for k=1:numel(d.inputPins)
    data(k+1) = readDigitalPin(d.arduino,d.inputPins{k});
end

if numel(d.inputPins)==0
    data = [];
end

% These is no timing information returned, so use getSecs 
framenumber = GetSecs;

data = double(data);
data(1) = framenumber;