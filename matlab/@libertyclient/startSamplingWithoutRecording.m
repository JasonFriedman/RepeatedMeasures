% STARTSAMPLINGWITHOUTRECORDING - activate the markers, sample but don't record 
%
% The last frame only is stored in memory until the recording is stopped
% 
% startSamplingWithoutRecording(lc)

function thistrial = startSamplingWithoutRecording(lc,thistrial)

codes = messagecodes;

m.parameters = lc.numsensors;
m.command = codes.startwithoutrecord;
sendmessage(lc,m,'startWithoutRecord');
