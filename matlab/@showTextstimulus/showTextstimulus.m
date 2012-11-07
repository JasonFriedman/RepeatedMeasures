% showTextstimulus - class representing "show Text" stimulus

function [v,params] = showTextstimulus(inputParams,experimentdata)

params.name = {'text'};
params.type = {'string'};
params.description = {'The text to display'};
params.required = 1;
params.default = {[]};
params.classdescription = 'Show a string of text for the whole trial';
params.classname = 'showTextstimulus';
params.parentclassname = 'stimulus';
if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

v = class(v,'showTextstimulus',stimulus(parent));
