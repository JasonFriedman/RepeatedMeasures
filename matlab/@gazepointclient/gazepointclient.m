% GAZEPOINTCLIENT - create an object to connect to the gazepoint eye tracker server and send commands to it 
%
% [gc,params] = gazepointclient(inputParams,experiment,debug)
% server is the server to connect to (for this machine, use 'localhost')
% port is the TCP/IP port to connect on
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [gc,params] = gazepointclient(inputParams,experiment,debug)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'Connect to the gaze point server to sample from the eye tracker';
params.classname = 'gazepoint';
params.parentclassname = 'socketclient';

if nargout>1
    gc = [];
    return;
end

[gc,gcParent] = readParameters(params,inputParams);
   
gc = class(gc,'gazepointclient',socketclient(gcParent,experiment,debug));
