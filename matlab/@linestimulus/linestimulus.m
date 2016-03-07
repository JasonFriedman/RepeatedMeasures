% LINESTIMULUS - class representing "line" stimulus
% draw line with the details specified in a file / matrix
% The lines are specified as a centre (x,y), an angle, start radius and end radius

function [v,params] = linestimulus(inputParams,experimentdata)

params.name = {'linesFilename','lines','framesPerLine','color'};
params.type = {'string','matrix_n_6','number','matrix_1_3'};
params.description = {'A file containing 6 elements per row - the x,y of the center, the angle (in radians), the start radius, the end radius, in the range 0 to 1 and the thickness (in the stimuli directory),',...
'An array with the line data (same format as for linesFilename). Can specify either linesFilename or lines',...    
'number of frames to show each line for','The color of the line (RGB, 1x3 matrix, from 0 to 255)'};
params.required = [0 0 0 0];
params.default = {[],[],4,[255 0 0]};
params.classdescription = 'A line to be drawn in each frame';
params.classname = 'linestimulus';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

v = class(v,'linestimulus',stimulus(parent));

if isempty(v.linesFilename) && isempty(v.lines)
    error('Must specify in line either linesFilename or lines');
end

if ~isempty(v.linesFilename) && ~isempty(v.lines)
    error('Cannot specify both linesFilename and lines in line stimulus');
end

% Check that linesFilename exists
if ~isempty(v.linesFilename) && ~exist(['stimuli/' v.linesFilename],'file')
    error(['The line stimulus file stimuli/' v.linesFilename ' does not exist']);
end

