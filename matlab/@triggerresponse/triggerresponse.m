% triggerresponse - class representing "trigger" response, 
% i.e. the trial ends when an external trigger is received. Triggers
% on other channels will be marked in the marker column (but will have
% no effect on running

function [r,params] = triggerresponse(inputParams)


params.name = {'type','channel','up','numChannels'};
params.type = {'string','number','boolean','number'};
params.description = {'Type of trigger to wait for. Currently the only option is ''DAQ''. There must either be a DAQ device defined, or setup.MCtrigger=1',...
    'channel to wait for a trigger on (first channel = 1). Triggers on other channels will be marked but will not stop the trial.',...
    'whether the trigger is a high value (1) or a low value (0)',...
    'Number of channels to look at (mainly important for making other channels). The trigger channel must be <= number of channels'};
params.required = [1 1 0 0];
params.default = {'DAQ',1,1,8};
params.classdescription = 'The trial ends when the an external trigger is received';
params.classname = 'triggerresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'triggerresponse',response(parent));
