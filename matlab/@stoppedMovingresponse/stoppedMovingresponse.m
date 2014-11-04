% STOPPEDMOVING - end the trial when the subject has stopped moving
function [r,params] = stoppedMovingresponse(inputParams)

params.name = {'duration','startDistance','startState','endDistance'};
params.type = {'number','number','number','number'};
params.description = {'The amount of time you need to stop before ending the trial (s)',...
    'The minimum distance from the starting point to be considered moving',...
    'The state you need to be in to be considered starting to move (if using states with image stimuli)',...
    'Need to move less than or equal to this to be considered not moving'};
params.required = [0 0 0 0];
params.default = {500, 0.1, NaN, 0};
params.classdescription = 'This response is to stop a trial after the subject has stopped moving for a certain about of time.';
params.classname = 'stoppedMovingresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'stoppedMovingresponse',response(parent));

