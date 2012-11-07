% DOCALCULATIONS - do some calculations on the data, which can be requested from the client
%
% dataSummary = doCalculations(s,data)
%
% data is the last recorded data, it returns a struct with the the
% meanposition throughout the trial, and the mean final non-occluded position

function dataSummary = doCalculations(s,data)

nummarkers = (size(data,2)-2)/3;

for i=1:nummarkers
    % Store x,y,z
    markerpos = data(:,i*3-1:i*3+1);
    nancount(i) = length(find(isnan(markerpos(:,1))));
    % Calculate the mean across the trial
    markermean = nanmean(markerpos);
    % Take also the average over the last 10 good samples
    goodsamples = find(~isnan(markerpos(:,1)),10,'last');
    if nancount(i)<0.5 * length(markerpos)
        dataSummary.meanmarkerpositions(i,:) = markermean;
        dataSummary.finalpositions(i,:) = mean(markerpos(goodsamples,:));
        % Check if they were going forward most of the time
        maxy = max(markerpos(:,2));
        miny = markerpos(find(~isnan(markerpos(:,2)),1,'first'),2);
        tenpercent = 0.10*(maxy - miny) + miny;
        ninetypercent = 0.90 * (maxy - miny) + miny;
        startind = find(markerpos(:,2)>tenpercent,1,'first');
        endind = find(markerpos(:,2)>ninetypercent,1,'first');
        goodtrials = length(find(~isnan(markerpos(startind:endind,1))));
        thisgoingforward = length(find(diff(markerpos(startind:endind,2))>0)) / goodtrials;
        if ~isempty(thisgoingforward)
            goingforwardratio(i) = thisgoingforward;
        else
            goingforwardratio(i) = NaN;
        end
    else
        dataSummary.meanmarkerpositions(i,:) = [NaN NaN NaN];
        dataSummary.finalpositions(i,:) = [NaN NaN NaN];
        goingforwardratio(i) = NaN;
    end
end

dataSummary.goingforwardratio = max(goingforwardratio);
dataSummary.meanposition = nanmean(dataSummary.meanmarkerpositions);
dataSummary.meanfinalposition = nanmean(dataSummary.finalpositions);
% Positions of both markers
dataSummary.meanpositions = dataSummary.meanmarkerpositions;
dataSummary.meanfinalpositions = dataSummary.finalpositions;

dataSummary.nancount = max(nancount) / length(markerpos);
