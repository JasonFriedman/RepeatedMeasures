% SETUPRECORDING - load the data file. 
% In this case, the file is the data to load rather than the file to save
% It should be in a directory called emulated
%
% Note that these files have an identical format to the saved fastrak files.
% 
function tc = setupRecording(tc,filename,maxtime,windowNum)

[pathstr,name] = fileparts(filename);

data = load(['emulated/' pathstr '/' 'ft_' name '.csv']);

% make the first column relative to the start of the file
data(:,1) = data(:,1) - data(1,1);

% ignore the last column
tc.data = data(:,1:7);

% clear the global variable to keep track of the time
global TRACKEREMULATORCLIENT_LASTTIME;
global TRACKEREMULATORCLIENT_FIRSTTIME;

TRACKEREMULATORCLIENT_LASTTIME = [];
TRACKEREMULATORCLIENT_FIRSTTIME = [];
