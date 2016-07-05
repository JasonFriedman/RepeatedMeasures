% COLORINIMAGERESPONSE - class representing finishing a trial by reaching a
% location marked in an image by a specific color. To use this response,
% you need to use showPosition so we know where the position is on the
% screen. You can use showPosition with an invisible color if necessary
%
% e.g. trial ends when the cursor is in a certain shape
%
% r = colorInImageresponse(details)

function [r,params] = colorInImageresponse(inputParams)

params.name = {'imageNum','color','endtime','points','showPositionFeedback','distance'};
params.type = {'number','matrix_1_3','number','matrix_n_6','matrix_n_2','number'};
params.description = {'Image number to use (from those defined in setup)',...
    'color in the image that signfies the target',...
    'The amount of time you need to be at the target for (in seconds)',...
    'Points to earn for this trial (based on position at the end of the trial). Should be a n*6 matrix. Each row includes (1) image number, (2-4) RGB color (5) number of points (6) tolerance of RGB color (city-block distance)',...
    'Show position feedback at certain frames in trial. Each row has 2 columns: (1) image number, (2) frame number. Can only use one of points or showPositionFeedback',...
    'allowable cityblock distance from the color'};
params.required = [1 1 0 0 0 0];
params.default = {1,[0 0 0],0,[],[],0};
params.classdescription = 'The target(s) are defined by a color in an image';
params.classname = 'colorInImageresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'colorInImageresponse',response(parent));

if ~isempty(r.points) && ~isempty(r.showPositionFeedback)
    error('Can only use one of points or showPositionFeedback');
end
