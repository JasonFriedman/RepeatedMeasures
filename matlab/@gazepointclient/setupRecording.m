% SETUPRECORDING - set up a recording
% 
% setupRecording(gc,filename,maxtime)
% maxtime is the maximum amount of time (in seconds) that will be captured.
% You can stop the recording anytime before this maximum

function gc = setupRecording(gc,filename,maxtime,curWindow)

codes = messagecodes;

m.parameters = {filename,2,maxtime};
m.command = codes.setuprecording;
sendmessage(gc,m,'setupRecording');
