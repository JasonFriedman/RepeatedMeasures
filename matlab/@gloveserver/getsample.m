% GETSAMPLE - get the latest sample of data
% [data,framenumber] = getsample(g, numsamples))
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(g,numsamples)

if g.getRawData
    [pkt framenumber] = GloveMex(3);
else
    [pkt framenumber] = GloveMex(2);
end

if isempty(pkt)
    data = [];
else
    data = [framenumber pkt];
end
