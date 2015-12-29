% FINISHRECORDINGTRIAL - tell the device to do whatever it needs at the end of a trial (usually nothing)
%
% finishRecordingTrial(e)

function finishRecordingTrial(e)

devicelist = fields(e.devices);
for k=1:length(devicelist)
    finishRecordingTrial(e.devices.(devicelist{k}));
    writetolog(e,['Finished recording trial on ' devicelist{k}]);
end

if isempty(devicelist)
    fprintf('No devices to finish recording trial on\n');
    writetolog(e,'No devices to finish recording trial on');
end
