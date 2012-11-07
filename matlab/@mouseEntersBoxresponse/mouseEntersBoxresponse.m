% mouseEntersBoxresponse - class representing a target being selected by the mouse moving in the box
% r = mouseEntersBoxresponse(details)
% details may have the field "delayedFeedback", which indicates whether to display the feedback from the previous trial

function [r,params] = mouseEntersBoxresponse(inputParams)
    
params.name = {'targets','delayedFeedback'};
params.type = {'matrix','number'};
params.description = {'The target number(s) that the mouse needs to be moved into to end the trial.',...
    'Whether the feedback should be delayed until the next trial.'};
params.required = [1 0];
params.default = {[],0};
params.classdescription = 'The response is moving the mouse into one of the specified boxes (which can be invisible)';
params.classname = 'mouseEntersBoxresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);
r = class(r,'mouseEntersBoxresponse',response(parent));
