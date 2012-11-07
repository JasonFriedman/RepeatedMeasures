% STARTRECORDING - start sampling
%
% The data is stored in memory until the recording is stopped
% 
% Usually filename and recordingTime are ignored here
% 
% startRecording(sc,filename,recordingTime)

function startRecording(gfc,filename,recordingTime)

startRecording(gfc.glove,filename,recordingTime);
startRecording(gfc.tracker,filename,recordingTime);

