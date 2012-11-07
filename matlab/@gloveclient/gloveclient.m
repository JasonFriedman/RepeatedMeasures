% GLOVECLIENT - create an object to connect to the glove server and send commands to it 
%
% gc = gloveclient(inputParams,experiment,debug)
% inputParams.server is the server to connect to (for this machine, use 'localhost')
% inputParams.port is the TCP/IP port to connect on
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [gc,params] = gloveclient(inputParams,experiment,debug)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'Connect to the cyberglove server to collect glove data';
params.classname = 'glove';
params.parentclassname = 'socketclient';

if nargout>1
    gc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[gc,parent] = readParameters(params,inputParams);
   
gc = class(gc,'gloveclient',socketclient(parent,experiment,debug));
