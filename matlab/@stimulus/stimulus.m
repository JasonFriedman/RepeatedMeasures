% STIMULUS - class representing a stimulus type
% In general, these classes do not have any members

function [s,params] = stimulus(inputParams,experimentdata)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'Superclass for all the stimuli';
params.classname = 'stimulus';

if nargout>1
    s = [];
    return;
end

s.dummy = [];
s = class(s,'stimulus');
