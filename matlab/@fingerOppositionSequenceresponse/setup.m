% SETUP - make any changes that need to be made to thistrial before starting the event
%
% e.g. set thistrial.sampleWhenNotRecording=1

function thistrial = setup(r,thistrial)

if ~thistrial.recording
    thistrial.sampleWhenNotRecording = 1;
end

thistrial.fingersequence = repmat(r.sequence,1,r.repetitions);
thistrial.sequenceposition = 0;
