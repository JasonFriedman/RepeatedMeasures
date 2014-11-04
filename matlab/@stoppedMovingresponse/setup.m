% SETUP - make any changes that need to be made to thistrial before starting the event
%
% e.g. set thistrial.sampleWhenNotRecording=1

function thistrial = setup(r,thistrial)


% movement stages:
% -1: has not started
% 0: started moving
% 1 : is moving less than threshold, waiting for enough time to pass
% 2: has stopped moving

thistrial.movementStage = -1;
thistrial.startMovementLocation = [NaN NaN];
