% FIXATIONSTIMULUS - show a fixation point for the stimulus

function [f,params] = fixationstimulus(inputParams,experimentdata)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'Displays a fixation point in the center of the screen';
params.classname = 'fixationstimulus';
params.parentclassname = 'stimulus';

if nargout>1
    f = [];
    return;
end

[f,parent] = readParameters(params,inputParams);

f = class(f,'fixationstimulus',stimulus(parent));
