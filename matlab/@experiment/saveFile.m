% SAVEFILE - tell all devices to save the file
%
% saveFile(e)

function saveFile(e)

devicelist = fields(e.devices);
for k=1:length(devicelist)
    saveFile(e.devices.(devicelist{k}));
    writetolog(e,['Saved file on ' devicelist{k}]);
end

if isempty(devicelist)
    fprintf('No devices to save file with\n');
    writetolog(e,'No devices to save file with');
end

