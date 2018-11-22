% BLUETERACLIENT - create an object to connect to the bluetera server and send commands to it 
%
% bt = blueteraclient(inputParams,experiment,debug)
% inputParams.server is the server to connect to (for this machine, use 'localhost')
% inputParams.port is the TCP/IP port to connect on
% inputParams.addresses is a cell array with the hardware addresses of the sensors (gems) to be used
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [rc,params] = blueteraclient(inputParams,experiment,debug)

params.name = {'addresses'};
params.type = {'cellarray'};
params.description = {'cell array with the hardware addresses of the sensors to be used'};
params.required = [1];
params.default = {[]};
params.classdescription = 'Connect to a bluetera server to record orientation + acceleration data';
params.classname = 'bluetera';
params.parentclassname = 'socketclient';

if nargout>1
    rc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[rc,parent] = readParameters(params,inputParams);

rc.numsensors = numel(rc.addresses);

rc = class(rc,'blueteraclient',socketclient(parent,experiment,debug));
