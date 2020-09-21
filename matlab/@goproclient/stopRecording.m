% STOPRECRODING - stop recording from the device
% 
% stopRecording(gc)

function stopRecording(gc)

codes = messagecodes;

m.parameters = [];
m.command = codes.GOPRO_stoprecording;
sendmessage(gc,m,'GOPRO_stoprecording');
