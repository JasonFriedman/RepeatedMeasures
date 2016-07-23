% SERIALPORTCLIENT - connect to a server via a serial connection (e.g. for sampling data from Arduino)

function [sc,params] = serialportclient(inputParams,experiment,debug)

params.name = {'protocol','numcharacters','numvalues'};
params.type = {'string','number','number'};
params.description = {'Type of server to connect to (currently ''Arduino'' is the only option). For Arduino, the character s is sent on the serial port, and a comma separated list is expected in return','Number of characeters in total per sample','Number of values per sample'};
params.required = [1 0 0];
params.default = {'Arduino',16,2};
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