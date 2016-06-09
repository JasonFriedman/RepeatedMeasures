% GETSAMPLE - get the latest sample of data (when in continous mode)
% To get a sample when not running continuously, use getsinglesample
%
% [data,framenumber] = getsample(k,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(l,nummarkers)

if ~l.sampleContinuously
    [data,framenumber] = getsinglesample(l,nummarkers);
    return;
end

datalength = 6;

data = zeros(1,nummarkers*datalength+2);
tmpdata = G4Mex(3,nummarkers);
if numel(tmpdata)>0
    data(1:end-1) = tmpdata;
end
framenumber = data(1);
data(end) = GetSecs;