% PEDALSTART - constructor for class representing to start when a pedal is pressed

function [p,params] = pedalstart(inputParams,experimentdata)

params.name = {'joystickType','joystickButton'};
params.type = {'number','number'};
params.description = {'The type of joystick (1 = the z axis starts the trial, 2 = a button (specified in joystickButton) starts the trial)',...
    'The joystick button to start the trial (only used when joystickType=2)'};
params.required = [1 0];
params.default = {1,1};
params.classdescription = 'Start the trial by pressing a pedal';
params.classname = 'pedalstart';
params.parentclassname = 'start';

if nargout>1
    p = [];
    return;
end

[p,parent] = readParameters(params,inputParams);

p = class(p,'pedalstart',start(parent));
