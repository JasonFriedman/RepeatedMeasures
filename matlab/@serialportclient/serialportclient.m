% SERIALPORTCLIENT - connect to a server via a serial connection (e.g. for sampling data from Arduino)

function [sc,params] = serialportclient(inputParams,experiment,debug)

params.name = {'protocol'};
params.type = {'string'};
params.description = {'Type of server to connect to (currently ''Arduino'' is the only option)'};
params.required = [1];
params.default = {'Arduino'};
params.classdescription = 'Connect to a serial port and sample from it';
params.classname = 'serialport';
params.parentclassname = 'socketclient';

if nargout>1
    sc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[sc,parent] = readParameters(params,inputParams);

sc = class(sc,'serialportclient',socketclient(parent,experiment,debug));