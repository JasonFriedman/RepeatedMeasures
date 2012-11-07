% showImagesstimulus - class representing "showImage" stimulus (i.e. don't record)

function [v,params] = showImagestimulus(inputParams,experimentdata)

params.name = {'stimuli'};
params.type = {'number'};
params.description = {'The image number to show (the image filenames should be listed in setup.images in a cell array).'};
params.required = 1;
params.default = {[]};
params.classdescription = 'Show a single image for the whole trial';
params.classname = 'showImagestimulus';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

if numel(experimentdata.images) < v.stimuli
    error(['There are not enough images in setup.images (there needs to be at least ' v.stimuli ')']);
end

v = class(v,'showImagestimulus',stimulus(parent));
