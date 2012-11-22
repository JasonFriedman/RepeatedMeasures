% nonestimulus - class representing no stimulus 

function [v,params] = nonestimulus(inputParams,experimentdata)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'This is for when no stimulus is required. It does nothing.';
params.classname = 'nonestimulus';
params.parentclassname = 'stimulus';
if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

v = class(v,'nonestimulus',stimulus(parent));
