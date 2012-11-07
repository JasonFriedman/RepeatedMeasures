% BUTTONPRESSRESPONSE - class representing "button press" response

function [r,params] = buttonPressresponse(inputParams)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'The response is pressing a button, using a button box connected to a DAQ card';
params.classname = 'buttonPressresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'buttonPressresponse',response(parent));
