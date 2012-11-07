% STOPRECORDING - stop recording and deactivate the markers
% The data is now written to disk 
% 
% stopRecording(oc)

function stopRecording(oc)

OptotrakDeActivateMarkers(oc);

codes = messagecodes;

m.parameters = [];
m.command = codes.stoprecording;
sendmessage(oc,m,'stopRecording');
