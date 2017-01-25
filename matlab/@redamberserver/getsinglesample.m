% GETSINGLESAMPLE - get a single sample of data
% [data,framenumber] = getsinglesample(k,nummarkers)
%
%
% It should produce a 1xN array of data

function [data,framenumber] = getsinglesample(l,nummarkers)

if nargin<2
    nummarkers = l.numsensors;
end

[data,framenumber] = getsample(l,nummarkers);
