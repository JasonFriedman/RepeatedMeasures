% keyboardresponse - class representing "keyboard" response

function [r,params] = keyboardresponse(inputParams)

params.name = {'keytopress'};
params.type = {'ignore'};
params.description = {'Key(s) to press to end the trial (default space). It should be a string (e.g. ''c'' or ''space'') or a cell array of strings'};
params.required = 0;
params.default = {KbName('space')};
params.classdescription = 'This response is pressing a key on the keyboard';
params.classname = 'keyboardresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

if isfield(inputParams,'keytopress')
    if ~iscell(inputParams.keytopress)
        r.keytopress = KbName(inputParams.keytopress);
    else
        for m=1:numel(inputParams.keytopress)
            r.keytopress(m) = KbName(inputParams.keytopress{m});
        end
    end
end

r = class(r,'keyboardresponse',response(parent));
