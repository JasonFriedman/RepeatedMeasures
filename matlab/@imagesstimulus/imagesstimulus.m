% imagesstimulus - class representing "images" stimulus

function [v,params] = imagesstimulus(inputParams,experimentdata)

stateTransitions.name = {'currentState','position','distanceAllowed','minimumDistance','penTouching','timeElapsed','newState','positionType','colorDistance'};
stateTransitions.type = {'number','matrix','number','number','number','number','number','number','number'};
stateTransitions.description = {'The state the program is currently in',...
    'Either the position needed to trigger the change (index of the positions in targetPosition) if positionType=0, otherwise the color (1x3 matrix) from the image specified in positionType',...
    'the maximum distance from the position that will trigger the change (i.e. distance must be less than this), ignored if positionType>0',...
    'the minimum distance from the position that will trigger the change (i.e. distance must be greater than this), ignored if positionType>0',...
    'whether the pen must be touching (If not using a tablet set to 0, for a tablet 0 = doesn''t matter, 1 = must touch, 2 = must not touch)',...
    'the minimum amount of time that has elasped since arriving in this state (in seconds)','the state to move to if all the conditions are satisfied',...
    ['positionType = 0 means to use positions from targetPosition, positionType>1 means to use a color from image number position (e.g. position=2 means use image 2). In this case' ...
    ' specify the color in position'],'allowable cityblock distance from the color (only used if positionType>0)'};
stateTransitions.required = [1 1 1 0 0 0 1 0 0];
stateTransitions.default = {1,1,1,0,0,0,1,0,0};
stateTransitions.classdescription = 'Describes of how to transition from state to state. The current state corresponds to the image that will be shown (i.e. row from stimuli)';
stateTransitions.classname = 'stateTransitions';

params.name = {'stimuli','stateTransitions','dimensionsToUse'};
params.type = {'matrix',stateTransitions,'matrix'};
params.description = {['An n x 4 or n x 6 matrix. The first column is the image number, the second the start time (frame number), ' ...
    'the third the end time (frame number), and the fourth the amount of noise to add (0 for none). If there are 4 columns, the image',...
    'is displayed in the center of the screen. If there are 6 columns, the last two indicate the location (center of the image)'],...
    ['A description of the state transitions. Each trial starts in state 1. The image shown is equal to the state number (specified in stimuli).'...
    'The times in stimuli are ignored if stateTransitions is non-empty (unless the start time is -Inf, in which case that image will be shown until the trial starts).'],...
    ['Dimensions to use to compare the positions , e.g. to just use x and y and not z, set to [1 2]. Default is to use xy ([1 2]. The number of '... 
    'dimensions should match the number of dimensions of the targets as defined in targetPosition. If using statetransitions and positionType>0, this is ignored.']};
    
params.required = [1 0 0];
params.default = {[],[],[1 2]};
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

if ~isempty(v.stateTransitions) && ~iscell(v.stateTransitions)
    tmp = v.stateTransitions;
    v.stateTransitions = [];
    v.stateTransitions{1} = tmp;
end

% Make sure there are enough images
minNumImages = max(v.stimuli(:,1));
if numel(experimentdata.images) < minNumImages
    error('There are not enough images specified (only %d) whereas there needs to be at least %d',numel(experimentdata.images),minNumImages);
end
v = class(v,'imagesstimulus',stimulus(parent));
