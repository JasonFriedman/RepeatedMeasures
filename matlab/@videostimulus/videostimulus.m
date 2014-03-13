% videostimulus - class representing "videos" stimulus

function [v,params] = videostimulus(inputParams,experimentdata)

params.name = {'filename'};
params.type = {'string'};
params.description = {'Filename of the video (in the stimuli directory)'};
params.required = 1;
params.default = {'filename.avi'};
params.classdescription = 'Play back a video';
params.classname = 'video';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

% Check that the video file exists
if ~exist(['stimuli/' v.filename '.avi'],'file')
    error(['The video file to play stimuli/' v.filename '.avi does not exist']);
end

v = class(v,'videostimulus',stimulus(parent));
