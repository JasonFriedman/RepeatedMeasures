% GETSAMPLE - get a simulated sample
function [data,framenumber] = getsample(d,nummarkers) %#ok<INUSD>
secs = GetSecs;
data = double([d.sampleFcn(secs) secs]);
framenumber = secs;
