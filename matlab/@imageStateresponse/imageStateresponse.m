% IMAGESTATERESPONSE - trial ends when a particular state is reached
% This only works if using images stimuli with state transitions
%
% r = imageStateresponse(details)

function [r,params] = imageStateresponse(inputParams)

params.name = {'state','feedbackFunction'};
params.type = {'number','string'};
params.description = {'The number of the state (using images stimuli) the program needs to be in to finish the trial',...
    ['The name of a user-supplied function that will provide feedback for this image. The function will receive the input:' ...
    'thistrial = feedback(r,e,thistrial,previoustrial,experimentdata,dataSummary,results) and can change thistrial as needed. Leave ' ...
    'blank (default) if not using']};
params.required = [1 0];
params.default = {1, ''};
params.classdescription = 'The target is a state (using images stimuli)';
params.classname = 'imageStateresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'imageStateresponse',response(parent));
