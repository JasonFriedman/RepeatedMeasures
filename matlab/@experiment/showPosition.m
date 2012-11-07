% SHOWPOSITION - show the positions using the relevant devices
% [lastposition,thistrial] = showPosition(e)

function [lastposition,thistrial,experimentdata] = showPosition(e,thistrial,experimentdata,frame)

devicelist = fields(e.devices);
for k=1:length(devicelist)
    [lastposition,thistrial] = showPosition(e.devices.(devicelist{k}),thistrial,experimentdata,e,frame);
end

