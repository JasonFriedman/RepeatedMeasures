% DOCALCULATIONS - do some calculations on the data, which can be requested from the client
%
% dataSummary = doCalculations(k,data)
%
% data is the last recorded data, it returns a struct with the new data added

function dataSummary = doCalculations(k,data)

codes = messagecodes;

% remove space bar presses
if ispc
    SPACE_BAR = 32;
else
    SPACE_BAR = 44;
end
data(data(:,2)==SPACE_BAR,2) = 0;

% first channel is clock time, last channel is markers
% Calculate when the keyboard was pressed
kb_pressed = find(data(:,2));
if ~isempty(kb_pressed)
    RT_sample = data(min(kb_pressed),1);
    firstpressedsample = data(min(kb_pressed),2);
else
    RT_sample = NaN;
    firstpressedsample = NaN;
end

dataSummary.kb_firstpressed = firstpressedsample;

firstframe = find(data(:,end)==codes.firstFrame,1,'first');
% RT defined as time from stimulus onset (first frame)
if isnan(RT_sample)
    dataSummary.kb_RT = NaN;
else
    dataSummary.kb_RT = RT_sample - data(firstframe,1);
end

% also, put non-zero lines in structure for saving to file (no point
% in saving all the non-zero lines)
dataSummary.toSave = data(any(data(:,2:end)'),:);
