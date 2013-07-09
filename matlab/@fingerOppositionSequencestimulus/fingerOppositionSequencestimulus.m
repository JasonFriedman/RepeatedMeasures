% FINGEROPPOSITIONSEQUENCESTIMULUS - provide feedback on finger opposition sequence (i.e. which fingers are considered to be touching)
function [v,params] = fingerOppositionSequencestimulus(inputParams,experimentdata)

params.name = {'feedbackType'};
params.type = {'number'};
params.description = {'1 = show the currently touching finges, 2 = show calibration information'};
params.required = [0];
params.default = {1};
params.classdescription = 'Provide feedback when using finger opposition sequence target';
params.classname = 'fingerOppositionSequence';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

v = class(v,'fingerOppositionSequencestimulus',stimulus(parent));
