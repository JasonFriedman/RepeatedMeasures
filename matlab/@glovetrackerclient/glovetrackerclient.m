% GLOVETRACKERCLIENT - create an object to connect to the glove and a tracker (fastrak or liberty) and send commands to them
%
% gfc = glovetrackerclient(inputParams,e,debug)
%
% inputParams.glove is the glove
% inputParams.tracker is the tracker (fastrak / liberty / emulator / fixed)
% inputParams.noVHT is set to 1 if the Virtualhand SDK is not installed
%
% See the html documentation for more details
%
% e is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [gfc,params] = glovetrackerclient(inputParams,e,debug)

[~,gloveParams] = gloveclient;
[~,gloveEmulatorParams] = gloveemulatorclient;
[~,fixedGloveParams] = fixedgloveclient;

[~,fastrakParams] = fastrakclient;
[~,libertyParams] = libertyclient;
[~,trackerEmulatorParams] = trackeremulatorclient;
[~,fixedTrackerParams] = fixedtrackerclient;

params.name = {'glove','tracker','noVHT'};
params.type = {{gloveParams,gloveEmulatorParams,fixedGloveParams},{fastrakParams,libertyParams,trackerEmulatorParams,fixedTrackerParams},'number'};
params.description = {'Parameters for a glove (i.e., host and port). Use "emulator" to use an emalated glove (see gloveemulator documentation for more details)',...
    'Parameters for a tracker (fastrak or liberty), use "emulator" to use an emulated tracker (see trackereumator documentation) or "fixed" for a fixed hand orientation (see fixedtracker documentation)',...
    'Set to 1 if you do not have or want to use the Virtualhand toolkit (limited functionality)'};
params.required = [1 1 0];
params.default = {fixedGloveParams,fixedTrackerParams,0};
params.classdescription = 'This connects to both a glove and tracker (fastrak / liberty) server (or emulator).';
params.classname = 'glovetracker';

if nargout>1
    gfc = [];
    return;
end

gfc = readParameters(params,inputParams);

if isfield(inputParams.glove,'gloveemulator')
    gfc.glove = gloveemulatorclient(inputParams.glove.gloveemulator,e,debug);
elseif isfield(inputParams.glove,'fixedglove')
    gfc.glove = fixedgloveclient(inputParams.glove.fixedglove,e,debug);
elseif isfield(inputParams.glove,'glove')
    gfc.glove = gloveclient(inputParams.glove.glove,e,debug);
else
    error('Unknown glove type');
end
if isfield(inputParams.tracker,'fastrak')
    gfc.tracker = fastrakclient(inputParams.tracker.fastrak,e,debug);
    gfc.trackerType = 'fastrak';
elseif isfield(inputParams.tracker,'liberty')
    gfc.tracker = libertyclient(inputParams.tracker.liberty,e,debug);
    gfc.trackerType = 'liberty';
elseif isfield(inputParams.tracker,'trackeremulator')
    gfc.tracker = trackeremulatorclient(inputParams.tracker.trackeremulator,e,debug);
    gfc.trackerType = 'emulator';
elseif isfield(inputParams.tracker,'fixedtracker')
    gfc.tracker = fixedtrackerclient(inputParams.tracker.fixedtracker,e,debug);
    gfc.trackerType = 'fixed';
else
    error('Unknown tracker type');
end

gfc = class(gfc,'glovetrackerclient');
