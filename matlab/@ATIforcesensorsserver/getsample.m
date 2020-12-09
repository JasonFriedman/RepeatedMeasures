% GETSAMPLE - get the latest sample of data
% [data,framenumber] = getsample(o,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(d,nummarkers)

    n = d.v.readStreamingSample;
    allsensors = n.getFtOrGageData;
    for m=numel(d.channels):-1:1
        data(1,m*6-5:m*6) =double(allsensors(d.channels(m),:)) ./ [repmat(d.counts_per_N,1,3) repmat(d.counts_per_Nm,1,3)];
    end
    % The timestamp is a 20 bit integer, followed by 12 bit fraction). So
    % divide by 2^12 = 4096 to get into seconds
    framenumber = n.getTimeStamp / 4096;
    data(end+1) = framenumber;