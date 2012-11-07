% FASTRAKCLIENT - create an object to connect to the fasttrak server and send commands to it 
%
% ftc = fastrakclient(inputParams,experiment,debug)
% inputParams.server is the server to connect to (for this machine, use 'localhost')
% inputParams.port is the TCP/IP port to connect on
% inputParams.numReceivers is the number of receivers that will be used
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [ftc,params] = fastrakclient(inputParams,experiment,debug)

params.name = {'numReceivers'};
params.type = {'number'};
params.description = {'Number of fastrak receivers present'};
params.required = 1;
params.default = {[]};
params.classdescription = 'Connect to a fastrak server to record fastrak 6D data';
params.classname = 'fastrak';
params.parentclassname = 'socketclient';

if nargout>1
    ftc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[ftc,parent] = readParameters(params,inputParams);
   
ftc = class(ftc,'fastrakclient',socketclient(parent,experiment,debug));
