% GLOVETRACKERCLIENT - create an object to connect to the glove and a tracker (fastrak or liberty) and send commands to them
%
% gfc = glovetrackerclient(glove,tracker)
% gloveserver is the glove server to connect to (for this machine, use 'localhost')
% gloveport is the TCP/IP port to connect on for the glove
% and similarly for the fastrak
%
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [gfc,params] = glovetrackerclient(inputParams,e,debug)

params.name = {'glove','tracker','noVHT'};
params.type = {'ignore','ignore','number'};
params.description = {'Parameters for a glove','Parameters for a tracker (fastrak or liberty)','Set to 1 if you do not have or want to use the Virtualhand toolkit'};
params.required = [1 1 0];
params.default = {[],[],0};
params.classdescription = 'This connects to both a glove and tracker (fastrak / liberty) server (or emulator).';
params.classname = 'glovetracker';

if nargout>1
    gfc = [];
    return;
end

gfc = readParameters(params,inputParams);

if isfield(inputParams.glove,'emulator')
    gfc.glove = gloveemulatorclient(inputParams.glove.emulator,e,debug);
else
    gfc.glove = gloveclient(inputParams.glove,e,debug);
end
if isfield(inputParams.tracker,'fastrak')
    gfc.tracker = fastrakclient(inputParams.tracker.fastrak,e,debug);
    gfc.trackerType = 'fastrak';
elseif isfield(inputParams.tracker,'liberty')
    gfc.tracker = libertyclient(inputParams.tracker.liberty,e,debug);
    gfc.trackerType = 'liberty';
elseif isfield(inputParams.tracker,'emulator')
    gfc.tracker = trackeremulatorclient(inputParams.tracker.emulator,e,debug);
    gfc.trackerType = 'emulator';
else
    error('Unknown tracker type');
end

gfc = class(gfc,'glovetrackerclient');
