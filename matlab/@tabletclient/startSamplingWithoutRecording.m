% STARTSAMPLINGWITHOUTRECORDING - activate the device and sample but don't record 
%
% The last frame only is stored in memory until the recording is stopped
% 
% startSamplingWithoutRecording(sc,thistrial,experimentdata)

function thistrial = startSamplingWithoutRecording(sc,thistrial,experimentdata)

codes = messagecodes;

% For the tablet, setupRecording must be run first (the filename is ignored)
m.parameters = {experimentdata.screenInfo.curWindow};
m.command = codes.TABLET_attachTablet;
sendmessage(sc,m,'TABLET_attachTablet');

m.parameters = 1; % number of markers
m.command = codes.startwithoutrecord;
sendmessage(sc,m,'startWithoutRecord');
