% MOUSECLICKSTART - constructor for class representing to start when the mouse enters a box

function [m,params] = mouseClickstart(inputParams,experimentdata)

params.name = {'targets'};
params.type = {'matrix'};
params.description = {'The target number(s) that the mouse needs to be in when the mouse button is pressed. If no target is specified, the click can be with the mouse at any location'};
params.required = 0;
params.default = {[]};
params.classdescription = 'The trial starts when the mouse button is clicked, optionally in a (possibly invisible) box';
params.classname = 'mouseClickstart';
params.parentclassanme = 'start';

if nargout>1
    m = [];
    return;
end

[m,parent] = readParameters(params,inputParams);

% Make sure these targets exist
if ~isempty(m.targets) && (~isfield(experimentdata,'mouseTargets') || max(m.targets) > size(experimentdata.mouseTargets,1))
    error('There are not enough mouseTargets defined (in the setup section) for the mouseClickstart');
end

m = class(m,'mouseClickstart',start(parent));
