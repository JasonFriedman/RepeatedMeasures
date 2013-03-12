% SETUP - make any changes that need to be made to thistrial before starting the event
%
% e.g. set thistrial.sampleWhenNotRecording=1

function thistrial = setup(r,thistrial)

if ~thistrial.recording
    thistrial.sampleWhenNotRecording = 1;
end

thistrial.completedMovements = 0;

% movement stages:
% -1: has not started
% 0 : has touched start point
% 1: has crossed mid line
% 2: has reached finish point
% (then it returns to -1)

thistrial.movementStage = -1;

