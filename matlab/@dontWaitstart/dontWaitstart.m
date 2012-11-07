% DONTWAITSTART - constructor for class representing to start immediately

function [d,params] = dontWaitstart(inputParams,experimentdata)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'Start the trial immediately';
params.classname = 'dontWaitstart';
params.parentclassname = 'start';

if nargout>1
    d = [];
    return;
end

[d,parent] = readParameters(params,inputParams);

d = class(d,'dontWaitstart',start(parent));
