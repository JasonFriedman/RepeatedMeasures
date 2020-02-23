% GOPROCLIENT - a client for connection to a gopro to record video
%
% gc = goproclient(server,port,experiment,debug)
%
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
%
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [gc,params] = goproclient(inputParams,experiment,debug)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'A client to connect to a GoPro camera to record video';
params.classname = 'gopro';
params.parentclassname = 'socketclient';

if nargout>1
    gc = [];
    return;
end

[gc,parent] = readParameters(params,inputParams);

gc = class(gc,'goproclient',socketclient(parent,experiment,debug,0));
