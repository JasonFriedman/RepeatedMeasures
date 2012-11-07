% imagesstimulus - class representing "images" stimulus

function [v,params] = imagesstimulus(inputParams,experimentdata)

params.name = {'stimuli'};
params.type = {'matrix'};
params.description = {['An n x 4 or n x 6 matrix. The first column is the image number, the second the start time, ' ...
    'the third the end time, and the fourth the amount of noise to add (0 for none). If there are 4 columns, the image',...
    'is displayed in the center of the screen. If there are 6 columns, the last two indicate the location (center of the image)']};
params.required = 1;
params.default = {[]};
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
