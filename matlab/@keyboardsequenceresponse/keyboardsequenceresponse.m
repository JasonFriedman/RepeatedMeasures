% KEYBOARDSEQUENCERESPONSE - class representing "keyboard" sequence response
% (i.e. you need to press a sequence of keys N times)

function [r,params] = keyboardsequenceresponse(inputParams)

params.name = {'sequence','repetitions'};
params.type = {'string','number'};
params.description = {'The sequence to be performed','The number of repetitions to be performed to complete the trial'};
params.required = [1 1];
params.default = {'',1};
params.classdescription = 'The response is pressing a certain sequence of keys N times';
params.classname = 'keyboardsequenceresponse';
params.parentclassanem = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'keyboardsequenceresponse',response(parent));
