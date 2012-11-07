% TARGETONSCREENRESPONSE - class representing reaching and touching a touchscreen
% r = targetOnScreenresponse(details)
% details may have the field "delayedFeedback", which indicates whether to display the feedback from the previous trial

function [r,params] = targetOnScreenresponse(inputParams)

params.name = {'delayedFeedback','checkGoingForward'};
params.type = {'number','number'};
params.description = {'Whether the feedback is to be shown in the following trial',...
    'Whether it should be checked that the marker continually moves forward'};
params.required = [0 0];
params.default = {0,0};
params.classdescription = 'Response of touching a target (e.g. on a touchscreen)';
params.classname = 'targetOnScreenresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'targetOnScreenresponse',response(parent));
