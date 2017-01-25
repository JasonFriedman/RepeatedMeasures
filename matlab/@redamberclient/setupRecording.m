% SETUPRECORDING - set up a recording
% 
% setupRecording(rc,filename,maxtime)
% maxtime is the maximum amount of time (in seconds) that will be captured.
% You can stop the recording anytime before this maximum

function rc = setupRecording(rc,filename,maxtime,curWindow)

codes = messagecodes;

m.parameters = {filename,rc.numsensors,maxtime};
m.command = codes.setuprecording;
sendmessage(rc,m,'setupRecording');
