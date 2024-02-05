% ARDUINOCLIENT - create an object to connect to the arduino server and send commands to it
%
% ac = arduinoclient(inputParams,experiment,debug)
% inputParams.server is the server to connect to (for this machine, use 'localhost')
% inputParams.port is the TCP/IP port to connect on
% inputParams.numchannels = numbers of channels to sample (must agree with the number of channels specified when running arduinoserver)
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [ac,params] = arduinoclient(inputParams,experiment,debug)

params.name = {'numchannels'};
params.type = {'number'};
params.description = {'Number of arduino channels to sample'};
params.required = 1;
params.default = {[]};
params.classdescription = 'This client connects to an arduino server to sample one or more digital channels';
params.classname = 'arduino';
params.parentclassname = 'socketclient';

if nargout>1
    ac = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[ac,parent] = readParameters(params,inputParams);

ac = class(ac,'arduinoclient',socketclient(parent,experiment,debug));
