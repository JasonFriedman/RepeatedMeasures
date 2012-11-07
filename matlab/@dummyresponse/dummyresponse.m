% DUMMYRESPONSE - class representing "dummy" response (i.e., no response)

function [r,params] = dummyresponse(inputParams)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'The dummy response does not record any response';
params.classname = 'dummyresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'dummyresponse',response(parent));
