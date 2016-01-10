% FORCESENSORSCLIENT - create an object to connect to the DAQ server and send commands to it
%
% fc = forcesensorsclient(inputParams,experiment,debug)
% inputParams.server is the server to connect to (for this machine, use 'localhost')
% inputParams.port is the TCP/IP port to connect on
% inputParams.numchannels = numbers of channels to sample (must agree with the number of channels specified when running DAQserver)
% inputParams.gains = gains for the sensors (1 x numchannels array)
% inputParams.offsets = offsets for the sensors (1 x numchannels array)
%
% The force for each sensor is calculated as offset(k) + gain(k)*DAQvoltage(k)
%
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [fc,params] = forcesensorsclient(inputParams,experiment,debug)

params.name = {'gains','offsets'};
params.type = {'matrix','matrix'};
params.description = {'Gains (one per channel), usually in N / V',...
    'Offsets (one per channel), usually in N'};
params.required = [1 1];
params.default = {1,0};
params.classdescription = 'This client connects to a DAQ server to sample force sensors.';
params.classname = 'forcesensors';
params.parentclassname = 'DAQclient';

if nargout>1
    fc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[fc,parent] = readParameters(params,inputParams);


fc = class(fc,'forcesensorsclient',DAQclient(parent,experiment,debug));
