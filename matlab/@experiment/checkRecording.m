% CHECKRECORDING - check recording on all devices
%
% checkRecording(e,filename,recordingTime)
%
% filename and recording time and only used for the video client
% (for the others, it is specified in setupRecording)


function checkRecording(e,dataSummary,experimentdata,thistrial)

devicelist = fields(e.devices);
for k=1:length(devicelist)
    checkRecording(e.devices.(devicelist{k}),e,dataSummary,experimentdata,thistrial);
    writetolog(e,['Checked recording on ' devicelist{k}]);
end

if isempty(devicelist)
    fprintf('No devices to check recording on\n');
    writetolog(e,'No devices to check recording on');
end
