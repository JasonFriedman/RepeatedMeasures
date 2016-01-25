% TARGETINSPACESTART - constructor for class representing to start when close to a target in 3D space

function [m,params] = targetInSpacestart(inputParams,experimentdata)

params.name = {'threshold','target','touching','dimensionsToUse'};
params.type = {'number','matrix','boolean','matrix'};
params.description = {'How close the marker needs to be to the target to start the trial',...
    'The response targets for this trial','whether the stylus needs to be touching (only relevant for the tablet)',...
    ['Dimensions to use to compare the start position , e.g. to just use x and y and not z, set to [1 2]. Default (NaN) is to use all dimensions. The number of '... 
    'dimensions should match the number of dimensions of the targets as defined in targetPosition']};
params.required = [0 1 0 0];
params.default = {1,[],0,NaN};
params.classdescription = 'The target(s) are locations in space';
params.classname = 'targetInSpacestart';
params.parentclassname = 'start';

if nargout>1
    m = [];
    return;
end

[m,parent] = readParameters(params,inputParams);

m = class(m,'targetInSpacestart',start(parent));
