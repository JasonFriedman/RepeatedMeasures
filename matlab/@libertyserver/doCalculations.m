% DOCALCULATIONS - do some calculations on the data, which can be requested from the client
%
% dataSummary = doCalculations(ls,data)
%
% data is the last recorded data, it returns a struct with the new data added
% NOTE: this only works on the first marker

function dataSummary = doCalculations(l,data)

i=1;
markerpos = data(:,i*3-1:i*3+1);
thisgoingforward = length(find(diff(markerpos(:,2))>0)) / size(data,1);

dataSummary.goingforwardratio = thisgoingforward;
dataSummary.meanposition = nanmean(markerpos);
dataSummary.meanfinalposition = markerpos(end,:);
