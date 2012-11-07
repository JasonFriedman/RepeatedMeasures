% START - class representing the way a trial is started
% In general, these classes do not have any members

function [s,params] = start(inputParams,experimentdata)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'This is the superclass for the all the "start" classes, which determine how to start each trial';
params.classname ='start';

if nargout>1
    s = [];
    return;
end

s = readParameters(params,inputParams);

s = class(s,'start');
