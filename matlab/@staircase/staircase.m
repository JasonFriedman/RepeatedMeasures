% STAIRCASE - create a staircase
%
% [s,params] = staircase(inputParams,experiment,debug)
%
% You should not use this class directly, rather one of its children
% e.g. QUESTstaircase

function [s,params] = staircase(inputParams,experiment,debug)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'This is the superclass for all the staircases.';
params.classname = 'staircase';

if nargout>1
    s = [];
    return;
end

s.debug = debug;

s = readParameters(params,inputParams);

s = class(s,'staircase');
