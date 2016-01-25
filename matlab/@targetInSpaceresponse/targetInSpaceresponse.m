% TARGETINSPACERESPONSE - class representing reaching and touching somewhere in 3D space
% r = targetinSpaceresponse(details)
% details may have the fields:
% "delayedFeedback", which indicates whether to display the feedback from the previous trial
% "checkGoingForward", to ensure that they are moving foward at the start of the trial

function [r,params] = targetInSpaceresponse(inputParams)

params.name = {'delayedFeedback','checkGoingForward','targets','threshold','endtime','dimensionsToUse'};
params.type = {'number','number','matrix','number','number','matrix'};
params.description = {'Whether the feedback is to be shown in the following trial',...
    'Whether it should be checked that the marker continually moves forward',...
    'The possible targets for this trial',...
    'How close to the target the marker needs to be to hit it',...
    'The amount of time you need to be at the target for (in seconds)',...
    ['Dimensions to use to compare the target position , e.g. to just use x and y and not z, set to [1 2]. Default (NaN) is to use all dimensions. The number of '... 
    'dimensions should match the number of dimensions of the targets as defined in targetPosition']};
params.required = [0 0 1 0 0 0];
params.default = {0,0,[],3,0, NaN};
params.classdescription = 'The target(s) are locations in space';
params.classname = 'targetInSpaceresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'targetInSpaceresponse',response(parent));
