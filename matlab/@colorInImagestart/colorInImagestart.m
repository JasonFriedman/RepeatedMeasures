% COLORINIMAGESTART - class representing starting a trial by reaching a
% location marked in an image by a specific color. To use this starttrial,
% you need to use showPosition so we know where the position is on the
% screen. You can use showPosition with an invisible color if necessary
%
% e.g. trial starts when the cursor is in a certain shape
%
% r = colorInImagestart(details)

function [r,params] = colorInImagestart(inputParams,experimentdata)

params.name = {'imageNum','color','starttime','distance'};
params.type = {'number','matrix_1_3','number','number'};
params.description = {'Image number to use (from those defined in setup)',...
    'color in the image that signfies the target',...
    'The amount of time you need to be at the target for (in seconds)','allowable cityblock distance from the color'};
params.required = [1 1 0 9];
params.default = {1,[0 0 0],0,0};
params.classdescription = 'The start position are defined by a color in an image';
params.classname = 'colorInImagestart';
params.parentclassname = 'start';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'colorInImagestart',response(parent));