% STOPRECRODING - stop recording from the device
% 
% stopRecording(dc)

function stopRecording(dc)

codes = messagecodes;

m.parameters = [];
m.command = codes.stoprecording;
sendmessage(dc,m,'stopRecording');
