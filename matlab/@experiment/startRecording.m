% STARTRECORDING - start recording on all devices
% 
% startRecording(e,filename,recordingTime)
%
% filename and recording time and only used for the video client
% (for the others, it is specified in setupRecording)

function startRecording(e,filename,recordingTime)

    devicelist = fields(e.devices);
    for k=1:length(devicelist)
        startRecording(e.devices.(devicelist{k}),filename,recordingTime);
        writetolog(e,['Started recording on ' devicelist{k}]);
    end
    
    if isempty(devicelist)
        fprintf('No devices to start recording on\n');
        writetolog(e,'No devices to start recording on');
    end
