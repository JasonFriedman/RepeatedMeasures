% STOPRECRODING - stop recording from the device
% 
% stopRecording(dc)

function stopRecording(dc)

codes = messagecodes;

m.parameters = [];
m.command = codes.GOPRO_stoprecording;
sendmessage(dc,m,'GOPRO_stoprecording');
