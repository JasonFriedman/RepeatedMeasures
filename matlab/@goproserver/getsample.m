% GETSAMPLE - get the latest sample of data
% [data,framenumber] = getsample(s,nummarkers)
%
% It should produce a 1xN array of data
%
% This doesn't sample, so just return dummy data

function [data,framenumber] = getsample(s,nummarkers)

data = 0;
framenumber = 0;