% GETSINGLESAMPLE - get a single sample of data
% [data,framenumber] = getsinglesample(k,nummarkers,recordOrientation)
%
% This is usually used for testing, in general, continous mode
% is used during the experiment
%
% It should produce a 1xN array of data

function [data,framenumber] = getsinglesample(l,nummarkers)

if nargin<2
    nummarkers = l.numsensors;
end

data = [G4Mex(1,nummarkers) GetSecs];
framenumber = data(1);
