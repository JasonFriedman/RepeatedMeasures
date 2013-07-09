% BUTTONPRESSRESPONSE - class representing "button press" response for a 2AFC task

function [r,params] = buttonPressresponse(inputParams)

params.name = {'finishOnPress','leftButton','rightButton'};
params.type = {'boolean','number','number'};
params.description = {'Whether to finish the trial when a button is pressed',...
    'Button number representing the left button (1). This is used when deciding whether the subject made the correct choice (specified in targetNum)','Button number representing the right button (2)'};
params.required = [0 0 0];
params.default = {0,1,3};
params.classdescription = 'The response is pressing a button, using a button box connected to a DAQ card';
params.classname = 'buttonPressresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'buttonPressresponse',response(parent));
