% RECTANGLESTIMULUS - class representing "rectangle" stimulus
% draw rectangles with the height / width specified in a file / matrix

function [v,params] = rectanglestimulus(inputParams,experimentdata)

params.name = {'rectanglesFilename','rectangles','framesPerRectangle','color'};
params.type = {'string','matrix_n_5','number','matrix_1_3'};
params.description = {'A file containing 5 elements per row - the x,y of the top-left corner, and the width and height of the rectangles to draw (in the stimuli directory), in the range 0 to 1. The fifth element is whether to fill the rectangle (0 or 1)',...
'An array with the rectangle data (same format as for rectanglesFilename). Can specify either rectanglesFilename or rectangles',...    
'number of frames to show each rectangle for','The color of the rectangle (RGB, 1x3 matrix, from 0 to 255)'};
params.required = [0 0 0 0];
params.default = {[],[],4,[255 0 0]};
params.classdescription = 'A rectangle to be drawn in each frame';
params.classname = 'rectanglestimulus';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

v = class(v,'rectanglestimulus',stimulus(parent));

if isempty(v.rectanglesFilename) && isempty(v.rectangles)
    error('Must specify in rectangles either rectanglesFilename or rectangles');
end

if ~isempty(v.rectanglesFilename) && ~isempty(v.rectangles)
    error('Cannot specify both rectanglesFilename and rectangles in rectangle stimulus');
end

% Check that "rectanglesFilename" exists
if ~isempty(v.rectanglesFilename) && ~exist(['stimuli/' v.rectanglesFilename],'file')
    error(['The rectangle stimulus file stimuli/' v.rectanglesFilename ' does not exist']);
end

