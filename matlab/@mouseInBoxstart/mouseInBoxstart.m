% MOUSEINBOXSTART - constructor for class representing to start when the mouse enters / is in a box

function [m,params] = mouseInBoxstart(inputParams,experimentdata)

params.name = {'targets'};
params.type = {'matrix'};
params.description = {'The target number(s) that the mouse needs to be in when to start the trial (from targets specified in the setup section under mouseTargets)'};
params.required = 1;
params.default = {1};
params.classdescription = 'The trial starts when the mouse enters (or is already in) a (potentially invisible) box';
params.classname = 'mouseInBoxstart';
params.parentclassanme = 'start';

if nargout>1
    m = [];
    return;
end

[m,parent] = readParameters(params,inputParams);

% Make sure these targets exist
if ~isempty(m.targets) && (~isfield(experimentdata,'mouseTargets') || max(m.targets) > size(experimentdata.mouseTargets,1))
    error('There are not enough mouseTargets defined (in the setup section) for the mouseInBoxstart');
end

m = class(m,'mouseInBoxstart',start(parent));
