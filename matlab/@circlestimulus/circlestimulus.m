% CIRCLESTIMULUS - class representing "circle" stimulus
% draw circles with the radii specified in a file

function [v,params] = circlestimulus(inputParams,experimentdata)

params.name = {'circlesFilename','framesPerCircle','color'};
params.type = {'string','number','matrix_1_3'};
params.description = {'A file containing the radii of the circles to draw (in the stimuli directory)','number of frames to show each circle for','The color of the circle (RGB, 1x3 matrix, from 0 to 255)'};
params.required = [1 0 0];
params.default = {[],4,[255 0 0]};
params.classdescription = 'A circle to be drawn in each frame';
params.classname = 'circlestimulus';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

v = class(v,'circlestimulus',stimulus(parent));

if ~exist(['stimuli/' v.circlesFilename],'file')
    error('The stimuli file %s does not exist',['stimuli/' v.circlesFilename]);
end
