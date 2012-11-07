% RESPONSE - class representing a response
% In general, these classes do not have any members

function [r,params] = response(inputParams)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'Super class representing the responses';
params.classname = 'response';

if nargout>1
    r = [];
    return;
end

r = readParameters(params,inputParams);

r = class(r,'response');
