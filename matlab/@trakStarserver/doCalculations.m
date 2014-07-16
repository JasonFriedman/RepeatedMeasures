% DOCALCULATIONS - do some calculations on the data, which can be requested from the client
%
% dataSummary = doCalculations(ts,data)
%
% data is the last recorded data, it returns a struct with the new data added
% NOTE: this only works on the first marker

function dataSummary = doCalculations(ts,data)

markerpos = data(:,1:3);
thisgoingforward = length(find(diff(markerpos(:,2))>0)) / size(data,1);

dataSummary.goingforwardratio = thisgoingforward;
dataSummary.meanposition = nanmean(markerpos);
dataSummary.meanfinalposition = markerpos(end,:);

% Make the times relative to the start of the trial (otherwise need too
% many digits to save the number)
for k=1:ts.numsensors
    data(:,k*8) = data(:,k*8) - data(1,k*8);
end

dataSummary.toSave = data;