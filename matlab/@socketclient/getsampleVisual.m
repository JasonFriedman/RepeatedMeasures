% GETSAMPLEVISUAL - get the sample, and rotate if appropriate

function [lastsampleVisual,thistrial] = getsampleVisual(tc,thistrial,frame)

lastsample = getsample(tc);
lastsample(2) = 1 - lastsample(2); % make y the usual way around

[lastsampleVisual,thistrial] = calculateLastPosition(tc,lastsample,thistrial,frame);
lastsampleVisual(2) = 1 - lastsampleVisual(2);
