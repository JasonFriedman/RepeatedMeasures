% DOCALCULATIONS - do some calculations on the data, which can be requested from the client
%
% dataSummary = doCalculations(s,data)
%
% data is the last recorded data, it returns a struct with the the

function dataSummary = doCalculations(s,data)

codes = messagecodes;

% first channel is clock time, last channel is markers
numchannels = size(data,2)-2;
firstpressedsample = NaN * ones(1,numchannels);

for i=1:numchannels
    % Calculate when the buttons were pressed
    dataSummary.pressed{i} = find(data(:,i+1));
    if ~isempty(dataSummary.pressed{i})
        firstpressedsample(i) = min(dataSummary.pressed{i});
    end
end
[RT_sample,dataSummary.firstpressed] = min(firstpressedsample);
if isnan(RT_sample)
    dataSummary.firstpressed = NaN;
end

firstframe = find(data(:,end)==codes.firstFrame,1,'first');
% RT defined as time from stimulus onset (first frame)
if isnan(RT_sample)
    dataSummary.RT = NaN;
else
    dataSummary.RT = data(RT_sample,1) - data(firstframe,1);
end

% also, put non-zero lines in structure for saving to file (no point
% in saving all the non-zero lines)
dataSummary.toSave = data(any(data(:,2:end)'),:);

