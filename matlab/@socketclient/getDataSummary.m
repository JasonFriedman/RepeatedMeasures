% GETDATASUMMARY - get the summary of the data from the last trial from the server
%
% dataSummary = getDataSummary(sc)

function dataSummary = getDataSummary(sc)

codes = messagecodes;

m.parameters = [];
m.command = codes.getDataSummary;
sendmessage(sc,m,'getDataSummary');
[dataSummary,success] = receivemessage(sc);

if success < 0
    error('Error in receiving data');
end
