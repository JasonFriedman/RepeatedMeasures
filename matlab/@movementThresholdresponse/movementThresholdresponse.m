% MOVEMENTTHRESHOLDRESPONSE - class representing "movement threshold" response (i.e., moving past a certain location)

function [r,params] = movementThresholdresponse()

params.name = {'thresholdAxis','thresholdAmount'};
params.type = {'number','number'};
params.description = {'The axis that needs to be moved along','The amount along that axis that needs to be crossed'};
params.required = [1 1];
params.default = {1,1};
params.classdescription = 'This response is moving past a certain location';
params.classname = 'movementThresholdresponse';
params.parentclassanem = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'movementThresholdresponse',response(parent));
