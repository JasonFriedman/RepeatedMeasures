% GETSAMPLE - get the latest sample of data
%
% Uses the psychtoolbox function GetMouse
% [data,framenumber] = getsample(k,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(k,nummarkers)

[x,y,buttons] = GetMouse;
secs = GetSecs;

data = [x y buttons];
framenumber = secs;
% Put the time in the last column
data = double([data secs]);

