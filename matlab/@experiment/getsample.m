% GETSAMPLE - get a sample from all devices
%
% getsample(e)

function lastsample = getsample(e)

devicelist = fields(e.devices);
for k=1:length(devicelist)
    lastsample.(devicelist{k}) = getsample(e.devices.(devicelist{k}));
end
