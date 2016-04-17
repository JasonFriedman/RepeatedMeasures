% GETSAMPLEVISUAL - get the sample, and rotate if appropriate. Tablet version also returns pressure (to save multiple calls to server)

function [lastsampleVisual,thistrial,pressure] = getsampleVisual(tc,thistrial,frame)

lastsample = getsample(tc);
if all(lastsample==0)
    lastsampleVisual = [NaN NaN];
else
    lastsample(2) = 1 - lastsample(2); % make y the usual way around
    
    [lastsampleVisual,thistrial] = calculateLastPosition(tc,lastsample(1:2),thistrial,frame);
    lastsampleVisual(2) = 1 - lastsampleVisual(2);
end

pressure = lastsample(4);
thistrial.pressure = pressure;
