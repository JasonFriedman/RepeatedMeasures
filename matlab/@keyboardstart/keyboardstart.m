% KEYBOARDSTART - constructor for class representing to start when a keyboard button is pressed

function [k,params] = keyboardstart(inputParams,experimentdata)

params.name = {'keytopress'};
params.type = {'ignore'};
params.description = {'Key to press to start the trial (default space)'};
params.required = 0;
params.default = {KbName('space')};
params.classdescription = 'The trial is started by pressing a key';
params.classname = 'keyboardstart';
params.parentclassname = 'start';

if nargout>1
    k = [];
    return;
end

[k,parent] = readParameters(params,inputParams);

k.Q = KbName('q');

if isfield(inputParams,'keytopress')
    k.keytopress = KbName(inputParams.keytopress);
end

k = class(k,'keyboardstart',start(parent));
