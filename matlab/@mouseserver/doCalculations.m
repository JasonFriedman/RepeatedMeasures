% DOCALCULATIONS - do some calculations on the data, which can be requested from the client
%
% dataSummary = doCalculations(k,data)
%
% data is the last recorded data, it returns a struct with the new data added

function dataSummary = doCalculations(k,data)

dataSummary.lastlocation = data(end,1:2);

% For the mouse, save only lines where something changed
changedlines = any(diff([zeros(1,size(data,2)-2);data(:,1:end-2)]),2);

dataSummary.toSave = data(changedlines,:);
