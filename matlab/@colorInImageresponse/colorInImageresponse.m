% COLORINIMAGERESPONSE - class representing finishing a trial by reaching a
% location marked in an image by a specific color. To use this response,
% you need to use showPosition so we know where the position is on the
% screen. You can use showPosition with an invisible color if necessary
%
% e.g. trial ends when the cursor is in a certain shape
%
% r = colorInImageresponse(details)

function [r,params] = colorInImageresponse(inputParams)

params.name = {'imageNum','startImageNum','color','colorStart','endtime','points','showPositionFeedback','showPathFeedback','showBackground','distance','durationFeedback'};
params.type = {'number','number','matrix_1_3','matrix_1_3','number','matrix_n_6','matrix_n_2','string','number','number','matrix_1_2'};
params.description = {'Image number to use (from those defined in setup)',...
    'Image number for when the movement has started, for use with timing feedback',...
    'color in the image that signfies the target',...
    'color in the image that signfies the start point, for use with timing feedback',...
    'The amount of time you need to be at the target for (in seconds)',...
    'Points to earn for this trial (based on position at the end of the trial). Should be a n*6 matrix. Each row includes (1) image number, (2-4) RGB color (5) number of points (6) tolerance of RGB color (city-block distance)',...
    'Show position feedback at certain frames in trial. Each row has 2 columns: (1) image number, (2) frame number. Can only use one of points or showPositionFeedback',...
    'Show feedback on the path taken at the end of the trial. This should either be 1, or an image, or empty. If it is an image, the color of the image will specify the color of the feedback',...
    'Whether to show backgroud during the feedback presentation. Either an image number, or empty',...
    'allowable cityblock distance from the color',...
    'Whether to provide feedback about the duration. If so, it should be a 1x2 matrix (1st is minimum time, 2nd is maximum time)'};
params.required = [1 1 0 0 0 0 0 0 0 0 0];
params.default = {1,1,[0 0 0],0,[0 0 0],[],[],[],[],0,[]};
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
