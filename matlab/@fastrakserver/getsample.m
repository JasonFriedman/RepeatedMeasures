% GETSAMPLE - get the latest sample of data
% [data,framenumber] = getsample(fts, numsamples))
%
% It should produce a 1xN array of data

function [data, framenumber] = getsample(fts,numsamples)

[pkt framenumber] = FastrakMex(2);
if isempty(pkt)
    data = [];
else
    data = [framenumber pkt];
end
