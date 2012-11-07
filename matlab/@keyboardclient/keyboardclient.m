% KEYBOARDCLIENT - create an object to connect to the keyboard server and send commands to it
%
% kc = keyboardclient(server,port,experiment,debug)
% server is the server to connect to (for this machine, use 'localhost')
% port is the TCP/IP port to connect on
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [kc,params] = keyboardclient(inputParams,experiment,debug)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'Connect to a keyboard server to record keystroke information';
params.classname = 'keyboard';
params.parentclassname = 'socketclient';

if nargout>1
    kc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[kc,parent] = readParameters(params,inputParams);
kc = class(kc,'keyboardclient',socketclient(parent,experiment,debug));
