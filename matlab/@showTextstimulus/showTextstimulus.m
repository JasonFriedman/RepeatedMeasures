% showTextstimulus - class representing "show Text" stimulus

function [v,params] = showTextstimulus(inputParams,experimentdata)

params.name = {'text','showBeforeStart'};
params.type = {'string','boolean'};
params.description = {'The text to display','Whether to show the text (also) before the trial starts'};
params.required = [1 0];
params.default = {'',1};
params.classdescription = 'Show a string of text for the whole trial';
params.classname = 'showTextstimulus';
params.parentclassname = 'stimulus';
if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

v = class(v,'showTextstimulus',stimulus(parent));
