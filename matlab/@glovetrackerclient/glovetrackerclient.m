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

params.name = {'glove','tracker'};
params.type = {'ignore','ignore'};
params.description = {'Parameters for a glove','Parameters for a tracker (fastrak or liberty)'};
params.required = [1 1];
params.default = {[],[]};
params.classdescription = 'This connects to both a glove and tracker (fastrak / liberty) server.';
params.classname = 'glovetracker';

if nargout>1
    gfc = [];
    return;
end

gfc = readParameters(params,inputParams);

gfc.glove = gloveclient(inputParams.glove,e,debug);
if isfield(inputParams.tracker,'fastrak')
    gfc.tracker = fastrakclient(inputParams.tracker.fastrak,e,debug);
    gfc.trackerType = 'fastrak';
elseif isfield(inputParams.tracker,'liberty')
    gfc.tracker = libertyclient(inputParams.tracker.liberty,e,debug);
    gfc.trackerType = 'liberty';
else
    error('Unknown tracker type');
end

gfc = class(gfc,'glovetrackerclient');
