% GETSAMPLE - get the latest sample of data 
%
% [data,framenumber] = getsample(k,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(r,nummarkers)

tmpdata = blueTeraMex(3);

data = [reshape(tmpdata',1,nummarkers*9) GetSecs];
framenumber = data(end-1); % From blueteraMex