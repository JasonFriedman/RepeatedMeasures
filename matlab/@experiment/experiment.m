% EXPERIMENT - setup an experiment
%
% e = experiment(protocolFile,resultDir)
% where protocolFile is an .xml file describing the protocol for this experiment

function e = experiment(protocolFile,resultDir)

e.filename = [];
e.resultDir = [];
e.protocol = [];
e.log_fp = [];
e.MCPresent = 0;
e.MCtrigger = [];
e.allclients = [];
e.devices = [];
e.staircases = [];
e.quest = [];

% This will contain information about all the recording devices
% It is put inside one "field" so that additional devices can be added
% without needing to change this file
thisfile = which('experiment');
% get the directory
pathstr = fileparts(thisfile);
% go up one directory
pathup = strrep(pathstr,'@experiment','');
% look for clients
clientdirs = dir([pathup '@*client']);
% look for staircases
staircasedirs = dir([pathup '@*staircase']);

if nargin==0
    % List all recording devices
    for k=1:length(clientdirs)
        thisclient = strrep(clientdirs(k).name,'@','');
        thisbase = strrep(thisclient,'client','');
        e.allclients{k} = thisbase;
    end
    e = class(e,'experiment');
    return;
end

% enforce 2 arguments
if exist('narginchk','builtin')
    narginchk(2,2);
else
    error(nargchk(2,2,nargin));
end

% Load the protocol file
tree = xmltree(protocolFile);
% convert it to a struct
e.protocol = convert(tree);

protocolfields = fields(e.protocol);
if numel(protocolfields)<2 || numel(protocolfields)>3 || ~isfield(e.protocol,'setup') || ~isfield(e.protocol,'trial')
    error('The protocol file must have 2 or 3 fields: setup and trial (and optionally common)');
end
    
% Check which recording devices are being used
for k=1:length(clientdirs)
    thisclient = strrep(clientdirs(k).name,'@','');
    thisbase = strrep(thisclient,'client','');
    e.allclients{k} = thisbase;
    if isfield(e.protocol.setup,thisbase)
        e.devices.(thisbase) = [];
    end
end

% Check which staircases are being used
for k=1:length(staircasedirs)
    thisstaircase = strrep(staircasedirs(k).name,'@','');
    thisbase = strrep(thisstaircase,'staircase','');
    if isfield(e.protocol.setup,thisbase)
        e.staircases.(thisbase) = [];
    end
end

e.filename = protocolFile;
e.resultDir = resultDir;
% If the result dir does not exist, create it
if ~exist(e.resultDir,'dir')
    mkdir(e.resultDir);
end

% Set up a log file
e.log_fp = fopen([e.resultDir '/logfile.txt'],'wt');
if e.log_fp == -1
    error('Cannot open logfile logfile.txt');
end

% If there is only one trial, turn it into a cell array
if ~isfield(e.protocol,'trial')
    error('There must be at least one trial in the protocol file');
end

if ~iscell(e.protocol.trial)
    tmptrial = e.protocol.trial;
    e.protocol = rmfield(e.protocol,'trial');
    e.protocol.trial{1} = tmptrial;
end

if isfield(e.protocol,'common')
    commonfields = fields(e.protocol.common);
else
    commonfields = [];
end

e.quest =  isfield(e.protocol,'quest');

for i=1:length(commonfields)
    for k=1:length(e.protocol.trial)
        e.protocol.trial{k}.(commonfields{i}) = e.protocol.common.(commonfields{i});
    end
end

if isfield(e.protocol.setup,'MCtrigger')
    e.MCPresent = 1;
end

e = class(e,'experiment');
