% imagesstimulus - class representing "images" stimulus

function [v,params] = imagesstimulus(inputParams,experimentdata)

params.name = {'stimuli','stateTransitions'};
params.type = {'matrix','matrix_n_5'};
params.description = {['An n x 4 or n x 6 matrix. The first column is the image number, the second the start time, ' ...
    'the third the end time, and the fourth the amount of noise to add (0 for none). If there are 4 columns, the image',...
    'is displayed in the center of the screen. If there are 6 columns, the last two indicate the location (center of the image)'],...
    ['An n x 5 matrix with the state transitions. Each trial starts in state 1. The image shown is equal to the state number (specified in stimuli).'...
    'The times in stimuli are ignored if stateTransitions is non-empty (unless the start time is -Inf, in which case that image will be shown until the trial starts).',...
    'The first column is the current state, the second column the current position' ...
    ' (from the positions in targetPosition), the third column the distance allowed (1 = screen width), the fourth column whether the pen must be touching (If not using a tablet set to 0, for a tablet 0 = doesn''t matter, 1 = must touch, 2 = must not touch)',...
    ' and the fifth column the state to change to when the conditions are satisfied']};
    
params.required = [1 0];
params.default = {[],[]};
params.classdescription = 'Display images (from those specified in the images section in setup), optionally with noise';
params.classname = 'imagesstimulus';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

% Make sure than v.stimuli is an n * 4 matrix
if size(v.stimuli,2)~=4 && size(v.stimuli,2)~=6
        error('The stimuli matrix for images must be an n * 4 or n*6 matrix');
end

% Make sure there are enough images
minNumImages = max(v.stimuli(:,1));
if numel(experimentdata.images) < minNumImages
    error(['There are not enough images specified (there needs to be at least ' num2str(minNumImages) ')']);
end
v = class(v,'imagesstimulus',stimulus(parent));
