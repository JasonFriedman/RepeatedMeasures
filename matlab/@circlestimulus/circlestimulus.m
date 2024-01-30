% CIRCLESTIMULUS - class representing "circle" stimulus
% draw circles with the radii specified in a file

function [v,params] = circlestimulus(inputParams,experimentdata)

params.name = {'circlesFilename','circleLocations','framesPerCircle','color','filled'};
params.type = {'string','matrix_n_n','number','matrix_1_3','boolean'};
params.description = {'A file containing the radii of the circles to draw (in the stimuli directory) and optionally also the x/y locations of the center (in columns 2 and 3) - must specificy this or circleLocations',...
    'An n * 1 or n*3 array containing the radii (n*1) or radii and xy locations (n*3) of the circle. Must specify this or circlesFilename',...
    'number of frames to show each circle for','The color of the circle outline (RGB, 1x3 matrix, from 0 to 255)',...
    'whether to fill the circle'};
params.required = [0 0 0 0 0];
params.default = {[],[],4,[255 0 0],0};
params.classdescription = 'A circle to be drawn in each frame';
params.classname = 'circlestimulus';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

v = class(v,'circlestimulus',stimulus(parent));

if (isempty(v.circleLocations) && isempty(v.circlesFilename)) || ...
        (~isempty(v.circleLocations) && ~isempty(v.circlesFilename))
    error('Can only specify one of circleLocations or circleFilenames');
end

if isempty(v.circleLocations) && ~exist(['stimuli/' v.circlesFilename],'file')
    error('The stimuli file %s does not exist',['stimuli/' v.circlesFilename]);
end
