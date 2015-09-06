% TARGETINSPACERESPONSE - class representing reaching and touching somewhere in 3D space
% r = targetinSpaceresponse(details)
% details may have the fields:
% "delayedFeedback", which indicates whether to display the feedback from the previous trial
% "checkGoingForward", to ensure that they are moving foward at the start of the trial

function [r,params] = targetInSpaceresponse(inputParams)

params.name = {'delayedFeedback','checkGoingForward','targets','threshold','endtime'};
params.type = {'number','number','matrix','number','number'};
params.description = {'Whether the feedback is to be shown in the following trial',...
    'Whether it should be checked that the marker continually moves forward',...
    'The possible targets for this trial',...
    'How close to the target the marker needs to be to hit it',...
    'The amount of time you need to be at the target for'};
params.required = [0 0 1 0 0];
params.default = {0,0,[],3,0};
params.classdescription = 'The target(s) are locations in space';
params.classname = 'targetInSpaceresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'targetInSpaceresponse',response(parent));
