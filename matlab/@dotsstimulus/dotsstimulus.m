% DOTSSTIMULUS - class representing "dots" stimulus

function [v,params] = dotsstimulus(inputParams,experimentdata)

params.name = {'dotsFilename','flip','type','framesPerDot','color','size'};
params.type = {'string','matrix_1_2','number','number','matrix_1_3','matrix'};
params.description = {'A file containing the locations of the dots to draw (in the stimuli directory). It should be an Nx2 array (each line is the x and y coordinate)',...
    'whether to flip the x (1) or y (1) values',...
    'type of dot, 0 = square, 1 = circle, 2 = high quality anti-aliased circle, 3 = ellipse',...
    'number of frames to show each dot for',...
    'The color of the rectangle (RGB, 1x3 matrix, from 0 to 255)',...
    'width of the dot (in pixels) (for types 1-3), or a 1x2 matrix (width and height) for type 4 (ellipse)'};
params.required = [1 0 0 0 0 0];
params.default = {[],[0 0],0,4,[255 255 255],10};
params.classdescription = 'A dot to be drawn in each frame';
params.classname = 'dotsstimulus';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

v = class(v,'dotsstimulus',stimulus(parent));

if v.type<3 && numel(v.size)>1
    error('If type is 0,1 or 2  the size must be 1');
end

if v.type==3 && numel(v.size)==1
    error('If type is 3, then size must be a 1x2 matrix (width and height or the ellipse');
end