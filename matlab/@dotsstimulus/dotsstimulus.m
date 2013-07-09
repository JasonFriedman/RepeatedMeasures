% DOTSSTIMULUS - class representing "dots" stimulus

function [v,params] = dotsstimulus(inputParams,experimentdata)

params.name = {'dotsFilename','flip','framesPerDot'};
params.type = {'string','matrix_1_2','number'};
params.description = {'A file containing the locations of the dots to draw (in the stimuli directory)','whether to flip the x (1) or y (1) values','number of frames to show each dot for'};
params.required = [1 0 0];
params.default = {[],[0 0],4};
params.classdescription = 'A dot to be drawn in each frame';
params.classname = 'dotsstimulus';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

v = class(v,'dotsstimulus',stimulus(parent));