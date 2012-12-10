% DOCALCULATIONS - do some calculations on the data, which can be requested from the client
%
% dataSummary = doCalculations(mb,data)
%
% data is the last recorded data, it returns a struct with the new data added

function dataSummary = doCalculations(mb,data)

%codes = messagecodes;

% does not do anything useful at the moment
dataSummary.dummy = 1;

dataSummary.meanpositions = mean(data);
dataSummary.toSave = data;
