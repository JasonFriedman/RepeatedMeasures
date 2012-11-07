% GETDATASUMMARY - get the summary of the data from the last trial from the server
%
% dataSummary = getDataSummary(e)
%
% Summary data for example with the optotrak is the mean position during
% the trial and at the end of the trial

function dataSummary = getDataSummary(e)

dataSummary = [];

devicelist = fields(e.devices);
for k=1:length(devicelist)
    thisdataSummary = getDataSummary(e.devices.(devicelist{k}));
    if ~isempty(thisdataSummary)
        thefields = fields(thisdataSummary);
        for m=1:length(thefields)
            dataSummary.(thefields{m}) = thisdataSummary.(thefields{m});
        end
        writetolog(e,['Got data summary for ' devicelist{k}]);
    end
end

if isempty(devicelist)
    fprintf('No devices to get data summary for\n');
    writetolog(e,'No devices to get data summary for');
end

