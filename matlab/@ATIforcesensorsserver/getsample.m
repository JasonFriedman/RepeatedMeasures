% GETSAMPLE - get the latest sample of data
% [data,framenumber] = getsample(o,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(d,nummarkers)

    n = d.v.readStreamingSample;
    allsensors = n.getFtOrGageData;
    data = allsensors(3,:);
    framenumber = n.getTimeStamp;
    data(end+1) = framenumber;