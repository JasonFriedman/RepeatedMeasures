% STARTSAMPLINGWITHOUTRECORDING - activate the markers, sample but don't record 
%
% The last frame only is stored in memory until the recording is stopped
% 
% startSamplingWithoutRecording(rc,thistrial,experimentdata)

function thistrial = startSamplingWithoutRecording(rc,thistrial,experimentdata)

codes = messagecodes;

m.parameters = rc.numsensors;
m.command = codes.startwithoutrecord;
sendmessage(rc,m,'startWithoutRecord');
