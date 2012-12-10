% DOCALCULATIONS - do some calculations on the data, which can be requested from the client
%
% dataSummary = doCalculations(k,data)
%
% data is the last recorded data, it returns a struct with the new data added

function dataSummary = doCalculations(g,data)

%codes = messagecodes;

% does not do anything useful at the moment
dataSummary.dummy = 1;

dataSummary.meanjointangles = mean(data);
dataSummary.toSave = data;
