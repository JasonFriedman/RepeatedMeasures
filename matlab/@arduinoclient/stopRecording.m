% STOPRECRODING - stop recording from the DAQ card 
% The time of any button presses will be calculated 
% 
% stopRecording(dc)

function stopRecording(dc)

codes = messagecodes;

m.parameters = [];
m.command = codes.stoprecording;
sendmessage(dc,m,'stopRecording');
