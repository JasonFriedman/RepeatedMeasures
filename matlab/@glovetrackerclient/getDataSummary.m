% GETDATASUMMARY - get the summary of the data from the last trial from the servers
%
% dataSummary = getDataSummary(gfc)

function dataSummary = getDataSummary(gfc)

dataSummaryGlove = getDataSummary(gfc.glove);
dataSummarytracker = getDataSummary(gfc.tracker);

thefields = fields(dataSummaryGlove);
for m=1:length(thefields)
    dataSummary.(thefields{m}) = dataSummaryGlove.(thefields{m});
end

thefields = fields(dataSummarytracker);
for m=1:length(thefields)
    dataSummary.(thefields{m}) = dataSummarytracker.(thefields{m});
end

