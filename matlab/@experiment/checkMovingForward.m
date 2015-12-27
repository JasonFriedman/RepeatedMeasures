% CHECKMOVINGFORWARD - check that they are (still) moving foward. This needs to be called twice, so that the velocity can be calculated

function [toAbort,thistrial] = checkMovingForward(e,thistrial,experimentdata,lastposition)

if nargin<4
    lastposition = getxyz(e);
end
toAbort = 0;

% If this is the second time
if isfield(thistrial,'positionpreviousframe')
    movementdiff = lastposition - thistrial.positionpreviousframe;
    % Project this onto the specified direction
    if size(movementdiff,1)==1
        movementdiff = movementdiff';
    end
    projection = dot(movementdiff,thistrial.checkMovingForward.direction);
    if projection < thistrial.checkMovingForward.minchangeframe
        toAbort=1;
    end 
    thistrial = rmfield(thistrial,'positionpreviousframe');
    if numel(thistrial.checkMovingForward.time)==1
        thistrial = rmfield(thistrial,'checkMovingForward'); 
        thistrial.checkMovingForward = [];
    else
        thistrial.checkMovingForward.time = thistrial.checkMovingForward.time(2:end);
    end
else
    % Set the current position, come back next frame to check it
    thistrial.positionpreviousframe = lastposition;
end
