% TARGETINSPACERESPONSE - class representing reaching and touching somewhere in 3D space
% r = targetinSpaceresponse(details)
% details may have the fields:
% "delayedFeedback", which indicates whether to display the feedback from the previous trial
% "checkGoingForward", to ensure that they are moving foward at the start of the trial

function [r,params] = targetInSpaceresponse(inputParams)

params.name = {'delayedFeedback','checkGoingForward','checkFixation','targets','threshold','endtime','dimensionsToUse',...
    'arrivalFeedbackStart','arrivalFeedbackEnd'};
params.type = {'number','number','number','matrix','number','number','matrix','number','number'};
params.description = {'Whether the feedback is to be shown in the following trial',...
    'Whether it should be checked that the marker continually moves forward',...
    'Whether fixation should be checked (with an eye tracker) - the bounding box is specified to the eye tracker server',...
    'The possible targets for this trial',...
    'How close to the target the marker needs to be to hit it',...
    'The amount of time you need to be at the target for (in seconds)',...
    ['Dimensions to use to compare the target position , e.g. to just use x and y and not z, set to [1 2]. Default (NaN) is to use all dimensions. The number of '... 
    'dimensions should match the number of dimensions of the targets as defined in targetPosition. Alternatively, it can be set to how much to multiply the values with each ' ...
    'row referring to one output dimension, e.g. if there are two xyz sensors, then [0.5 0 0 0.5 0 0;0 0.5 0 0 0.5 0]' ...
    'would generate an average of sensor 1 and 2. In this case, the number of rows should match the dimensions of the targets.'],...
    'If this number is not NaN, then when the target needs to arrive (in seconds) after to NOT get a "too early" feedback',...
    'If this number is not NaN, then when the target needs to arrive (in seconds) before to NOT get a "too late" feedback'};
params.required = [0 0 0 1 0 0 0 0 0];
params.default = {0,0,0,[],3,0, NaN, NaN, NaN};
params.classdescription = 'The target(s) are locations in space';
params.classname = 'targetInSpaceresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

if any(r.targets-round(r.targets))
    error('Targets must be indices (integers) describing which targets from the list, not the target locations');
end

r = class(r,'targetInSpaceresponse',response(parent));
