% DAQCLIENT - create an object to connect to the DAQ server and send commands to it
%
% dc = DAQclient(inputParams,experiment,debug)
% inputParams.server is the server to connect to (for this machine, use 'localhost')
% inputParams.port is the TCP/IP port to connect on
% inputParams.numchannels = numbers of channels to sample (must agree with the number of channels specified when running DAQserver)
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [dc,params] = DAQclient(inputParams,experiment,debug)

params.name = {'numchannels'};
params.type = {'number'};
params.description = {'Number of DAQ channels to sample'};
params.required = 1;
params.default = {[]};
params.classdescription = 'This client connects to a DAQ server to sample one or more channels (e.g. for a button box or force sensors).';
params.showPositionValues = 'Each channel gives one value. Use one row with 2 * numchannels + 1 columns, [min1 max1 min2 max2 ... time], or one row for each channel with 3 columns, [min max time].';
params.classname = 'DAQ';
params.parentclassname = 'socketclient';

if nargout>1
    dc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[dc,parent] = readParameters(params,inputParams);

dc = class(dc,'DAQclient',socketclient(parent,experiment,debug));
