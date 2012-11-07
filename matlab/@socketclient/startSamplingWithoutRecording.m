% STARTSAMPLINGWITHOUTRECORDING - activate the device and sample but don't record 
%
% The last frame only is stored in memory until the recording is stopped
% 
% startSamplingWithoutRecording(sc)

function thistrial = startSamplingWithoutRecording(sc,thistrial)

codes = messagecodes;

m.parameters = 1; % number of markers
m.command = codes.startwithoutrecord;
sendmessage(sc,m,'startWithoutRecord');
