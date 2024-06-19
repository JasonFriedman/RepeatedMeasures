% NIDAQCLIENT - create an object to connect to the NIDAQ server and send commands to it
%
% dc = NIDAQclient(inputParams,experiment,debug)
% inputParams.server is the server to connect to (for this machine, use 'localhost')
% inputParams.port is the TCP/IP port to connect on
% inputParams.numchannels = numbers of channels to sample (must agree with the number of channels specified when running DAQserver)
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [dc,params] = NIDAQclient(inputParams,experiment,debug)

params.name = {'numchannels'};
params.type = {'number'};
params.description = {'Number of NI DAQ channels to sample'};
params.required = 1;
params.default = {[]};
params.classdescription = 'This client connects to a NIDAQ server to sample one or more channels (e.g. for a button box or force sensors).';
params.classname = 'NIDAQ';
params.parentclassname = 'socketclient';

if nargout>1
    dc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[dc,parent] = readParameters(params,inputParams);

dc = class(dc,'NIDAQclient',socketclient(parent,experiment,debug));
