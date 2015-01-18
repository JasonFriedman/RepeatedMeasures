% showTextstimulus - class representing "show Text" stimulus

function [v,params] = showTextstimulus(inputParams,experimentdata)

params.name = {'text','showBeforeStart','color'};
params.type = {'string','boolean','matrix_1_3'};
params.description = {'The text to display','Whether to show the text (also) before the trial starts','Text color (each element 0 to 255)'};
params.required = [1 0 0];
params.default = {'',1,[255 255 255]};
params.classdescription = 'Show a string of text for the whole trial';
params.classname = 'showTextstimulus';
params.parentclassname = 'stimulus';
if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

v = class(v,'showTextstimulus',stimulus(parent));
