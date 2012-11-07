% STARTSAMPLINGWITHOUTRECORDING - activate the device and sample but don't record 
%
% The last frame only is stored in memory until the recording is stopped
% 
% startSamplingWithoutRecording(sc)

function thistrial = startSamplingWithoutRecording(gfc,thistrial)

thistrial = startSamplingWithoutRecording(gfc.glove,thistrial);
thistrial = startSamplingWithoutRecording(gfc.tracker,thistrial);
