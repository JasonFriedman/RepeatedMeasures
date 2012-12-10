% GETSAMPLE - return emulated data

function data = getsample(gc)

% we use a global variable to keep track of the time
global GLOVEEMULATORCLIENT_LASTTIME;
global GLOVEEMULATORCLIENT_FIRSTTIME;

if isempty(GLOVEEMULATORCLIENT_LASTTIME)
    GLOVEEMULATORCLIENT_LASTTIME = 0;
    GLOVEEMULATORCLIENT_FIRSTTIME = GetSecs;
end

% work out which sample to return
currentTime = GetSecs - GLOVEEMULATORCLIENT_FIRSTTIME;
samplenum = find(gc.data(:,1)>=currentTime,1);
if isempty(samplenum)
    samplenum = size(gc.data,1);
end
data = gc.data(samplenum,:);
