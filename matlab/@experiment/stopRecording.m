% STOPRECORDING - stop recording on all devices
%
% stopRecording(e)

function stopRecording(e)

devicelist = fields(e.devices);
for k=1:length(devicelist)
    stopRecording(e.devices.(devicelist{k}));
    writetolog(e,['Stopped recording on ' devicelist{k}]);
end

if isempty(devicelist)
    fprintf('No devices to stop recording on\n');
    writetolog(e,'No devices to stop recording on');
end
