% STYLUSBUTTONSTART - constructor for class representing to start when a tablet stylus button is pressed

function [s,params] = stylusButtonstart(inputParams,experimentdata)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'Start the trial when the tablet stylus button is pressed';
params.classname = 'stylusButtonstart';
params.parentclassname = 'start';

if nargout>1
    s = [];
    return;
end

[s,parent] = readParameters(params,inputParams);

s = class(s,'stylusButtonstart',start(parent));
