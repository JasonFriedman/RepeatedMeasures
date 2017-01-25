% GETSAMPLE - get the latest sample of data 
%
% [data,framenumber] = getsample(k,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(r,nummarkers)

tmpdata = redamberMex(3);

data = [reshape(tmpdata',1,nummarkers*8) GetSecs];
framenumber = data(end-1); % From redamberMex