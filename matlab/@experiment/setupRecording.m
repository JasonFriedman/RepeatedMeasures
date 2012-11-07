% SETUPRECORDING - setup the recording devices (but don't actually start)
%
% setupRecording(e,filename,maxseconds,curWindow)
%
% filename = filename to store data (prefix will be added for type of
% recording (e.g. opto_) and an appropriate suffix (.csv))
% maxseconds = maximum number of seconds to record (better to specify a
% little more than you need)

function setupRecording(e,filename,maxseconds,curWindow)

devicelist = fields(e.devices);
for k=1:length(devicelist)
    setupRecording(e.devices.(devicelist{k}),filename,maxseconds,curWindow);
    writetolog(e,['Setup recording on ' devicelist{k}]);
end

if isempty(devicelist)
    fprintf('No devices to setup recording on\n');
    writetolog(e,'No devices to setup recording on');
end
