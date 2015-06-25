%TRIGGERSTART - class representing to start when an external trigger is received
% e.g. from the DAQ card

function [t,params] = triggerstart(inputParams,experimentdata)

params.name = {'type','channel','up'};
params.type = {'string','number','boolean'};
params.description = {'Type of trigger to wait for. Currently the only option is ''DAQ''. There must either be a DAQ device defined, or setup.MCtrigger=1',...
    'channel to wait for a trigger on (first channel = 1)',...
    'whether the trigger is a high value (1) or a low value (0)'};
params.required = [1 1 0];
params.default = {'DAQ',1,1};
params.classdescription = 'The trial starts when the an external trigger is received';
params.classname = 'triggerstart';
params.parentclassname = 'start';

if nargout>1
    t = [];
    return;
end

[t,parent] = readParameters(params,inputParams);

t = class(t,'triggerstart',start(parent));
