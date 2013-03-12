% STARTSAMPLINGWITHOUTRECORDING - activate the device and sample but don't record 
%
% The last frame only is stored in memory until the recording is stopped
% 
% startSamplingWithoutRecording(gfc,thistrial,experimentdata)


function thistrial = startSamplingWithoutRecording(gfc,thistrial,experimentdata)

thistrial = startSamplingWithoutRecording(gfc.glove,thistrial,experimentdata);
thistrial = startSamplingWithoutRecording(gfc.tracker,thistrial,experimentdata);
