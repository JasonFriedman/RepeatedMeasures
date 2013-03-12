% STARTSAMPLINGWITHOUTRECORDING - start sample (but don't record) on all devices
%
% This may be ignored by some devices (e.g. the video recorder)
%
% startSamplingWithoutRecording(e,thistrial,experimentdata)

function thistrial = startSamplingWithoutRecording(e,thistrial,experimentdata)

devicelist = fields(e.devices);
for k=1:length(devicelist)
    startSamplingWithoutRecording(e.devices.(devicelist{k}), thistrial,experimentdata);
    writetolog(e,['Started sampling without recording on ' devicelist{k}]);
end

if isempty(devicelist)
    fprintf('No devices to start sampling on\n');
    writetolog(e,'No devices to start sampling on');
end
