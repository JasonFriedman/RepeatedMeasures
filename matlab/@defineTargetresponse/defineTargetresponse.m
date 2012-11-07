% DEFINETARGETRESPONSE - class representing a trial where the target is defined
% r = defineTargetResponse(details)
% It should have the field targetNum, specifying which target is being defined

function [r,params] = defineTargetresponse(inputParams)

params.name = {'targetNum'};
params.type = {'number'};
params.description = {'The number of the target in space that will be defined in this trial'};
params.required = [1];
params.default = {0};
params.classdescription = 'This response is to define a target for use later (e.g. with the response targetInSpace).';
params.classname = 'defineTargetresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'defineTargetresponse',response(parent));
