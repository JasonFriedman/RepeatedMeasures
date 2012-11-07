% VIDEOCLIENT - a client for connection to a program to record video
%
% vc = videoclient(server,port,experiment,debug)
%
% This is designed to work with "myAmCapWithSocket", a hacked version
% of the DirectShow demo AmCap. It sends signals through a socket
% regarding when to start, stop, filename, etc
%
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
%
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [vc,params] = videoclient(inputParams,experiment,debug)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'A client to connect to a program to record video';
params.classname = 'video';
params.parentclassname = 'socketclient';

if nargout>1
    vc = [];
    return;
end

[vc,parent] = readParameters(params,inputParams);

vc = class(vc,'videoclient',socketclient(parent,experiment,debug,1));
