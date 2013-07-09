% GETSAMPLE - get the latest sample of data
% [data,framenumber] = getsample(o,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(d,nummarkers)

[data,framenumber] = getsample(d.DAQserver,nummarkers);

% Apply the transformation from voltage to force (N)
data(2:nummarkers+1) = (data(2:nummarkers+1) - d.parameters(1,:)) .* d.parameters(2,:);