% GETSAMPLE - get the latest sample of data (when in continous mode)
% To get a sample when not running continuously, use getsinglesample
%
% [data,framenumber] = getsample(k,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(gs,nummarkers)

str = char(readline(gs.socket));

if isempty(str)
    data = [NaN NaN NaN GetSecs];
    framenumber = NaN;
    return
end

% ignore any "ACK" packets (these are just acknowledgements)
while strcmp(str(2:4),'ACK')
    str = char(readline(gs.socket));
end

% remove the '<REC ' at the beginning and ' />' at the end
str = str(5:end-3);
split = strsplit(str,'"');
numelements = floor(numel(split)/2);
for k=1:numelements
    data.(split{k*2-1}(2:end-1)) = str2double(split{k*2});
end

x = NaN;
y = NaN;
time = NaN;

if isfield(data,'BPOGX')
    x = data.BPOGX;
end
if isfield(data,'BPOGY')
    y = data.BPOGY;
end
if isfield(data,'TIME')
    time = data.TIME;
end

data = [x y time GetSecs];
framenumber = time;
