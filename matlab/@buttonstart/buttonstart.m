% BUTTONSTART - constructor for class representing to start when a button is pressed (using a DAQ box)

function [b,params] = buttonstart(inputParams,experimentdata)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'The trial starts when a button is pressed, using a button box connected to a DAQ card. To use this, setup.MCtrigger should be set to 1 (for input)';
params.classname = 'buttonstart';
params.parentclassname = 'start';

if nargout>1
    b = [];
    return;
end

if isempty(experimentdata.MCtrigger)
    error('Cannot use button start without setting setup.MCtrigger');
end

[b,parent] = readParameters(params,inputParams);

b = class(b,'buttonstart',start(parent));
