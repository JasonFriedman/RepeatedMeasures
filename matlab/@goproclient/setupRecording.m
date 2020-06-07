% SETUPRECORDING - set up a recording
% 
% setupRecording(dc,filename,maxtime)
% maxtime is the maximum amount of time (in seconds) that will be captured.
% You can stop the recording anytime before this maximum
%
% For the gopro, it just needs the filename

function gc = setupRecording(gc,filename,~,~)

codes = messagecodes;

m.parameters = {filename};
m.command = codes.GOPRO_setuprecording;
sendmessage(gc,m,'GOPRO_setuprecording');
