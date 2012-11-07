% TARGETINSPACESTART - constructor for class representing to start when close to a target in 3D space

function [m,params] = targetInSpacestart(inputParams,experimentdata)

params.name = {'threshold','target'};
params.type = {'number','matrix'};
params.description = {'How close the marker needs to be to the target to start the trial',...
    'The response targets for this trial'};
params.required = [0 1];
params.default = {1,[]};
params.classdescription = 'The target(s) are locations in space';
params.classname = 'targetInSpacestart';
params.parentclassname = 'start';

if nargout>1
    m = [];
    return;
end

[m,parent] = readParameters(params,inputParams);

m = class(m,'targetInSpacestart',start(parent));
