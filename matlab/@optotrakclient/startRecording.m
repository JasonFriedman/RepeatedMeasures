% STARTRECORDING - activate the markers and start recording 
%
% The data is stored in memory until the recording is stopped
% 
% startRecording(oc,filename,recordingTime)
% filename and recordingTime are ignored

function startRecording(oc,filename,recordingTime)

OptotrakActivateMarkers(oc);

codes = messagecodes;

m.parameters = [];
m.command = codes.startrecording;
sendmessage(oc,m,'startRecording');
