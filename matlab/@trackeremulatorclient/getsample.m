% GETSAMPLE - return emulated data

function data = getsample(gc)

% we use a global variable to keep track of the time
global TRACKEREMULATORCLIENT_LASTTIME;
global TRACKEREMULATORCLIENT_FIRSTTIME;

if isempty(TRACKEREMULATORCLIENT_LASTTIME)
    TRACKEREMULATORCLIENT_LASTTIME = 0;
    TRACKEREMULATORCLIENT_FIRSTTIME = GetSecs;
end

% work out which sample to return
currentTime = GetSecs - TRACKEREMULATORCLIENT_FIRSTTIME;
samplenum = find(gc.data(:,1)>=currentTime,1);
if isempty(samplenum)
    samplenum = size(gc.data,1);
end
data = gc.data(samplenum,:);