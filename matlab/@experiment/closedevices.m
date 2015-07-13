% CLOSEDEVICES - close recording and other devices
%
% closedevices(e)


function closedevices(e)

devicelist = fields(e.devices);
for k=1:length(devicelist)
    closedevice(e.devices.(devicelist{k}));
    close(e.devices.(devicelist{k}));
    writetolog(e,['Closed ' devicelist{k}]);
end

% Close the log file
closelog(e);