% IMAGESTATERESPONSE - trial ends when a particular state is reached
% This only works if using images stimuli with state transitions
%
% r = imageStateresponse(details)

function [r,params] = imageStateresponse(inputParams)

params.name = {'state'};
params.type = {'number'};
params.description = {'The number of the state (using images stimuli) the program needs to be in to finish the trial'};    
params.required = [1];
params.default = {1};
params.classdescription = 'The target is a state (using images stimuli)';
params.classname = 'imageStateresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'imageStateresponse',response(parent));
