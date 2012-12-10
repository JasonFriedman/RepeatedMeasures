% SETUPRECORDING - load the data file. 
% In this case, the file is the data to load rather than the file to save
% It should be in a directory called emulated
%
% Note that these files have an identical format to the saved cyberglove
% files.
% 
function gc = setupRecording(gc,filename,maxtime,windowNum)

[pathstr,name] = fileparts(filename);

data = load(['emulated/' pathstr '/' 'cg_' name '.csv']);

% make the first column relative to the start of the file
data(:,1) = data(:,1) - data(1,1);

% ignore the last column
gc.data = data(:,1:24);

% clear the global variable to keep track of the time
global GLOVEEMULATORCLIENT_LASTTIME;
global GLOVEEMULATORCLIENT_FIRSTTIME;

GLOVEEMULATORCLIENT_LASTTIME = [];
GLOVEEMULATORCLIENT_FIRSTTIME = [];
