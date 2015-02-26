% STARTSAMPLINGWITHOUTRECORDING - activate the markers, sample but don't record 
%
% The last frame only is stored in memory until the recording is stopped
% 
% startSamplingWithoutRecording(tc,thistrial,experimentdata)

function thistrial = startSamplingWithoutRecording(tc,thistrial,experimentdata)

codes = messagecodes;

m.parameters = tc.numsensors;
m.command = codes.startwithoutrecord;
sendmessage(tc,m,'startWithoutRecord');
