% STARTRECORDING - start sampling
%
% The data is stored in memory until the recording is stopped
% 
% Usually filename and recordingTime are ignored here
% 
% startRecording(sc,filename,recordingTime)

function startRecording(sc,filename,recordingTime)

codes = messagecodes;

m.parameters = [];
m.command = codes.startrecording;
sendmessage(sc,m,'startRecording');
