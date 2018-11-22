% SETUPRECORDING - set up a recording
% 
% setupRecording(dc,filename,maxtime)
% maxtime is the maximum amount of time (in seconds) that will be captured.
% You can stop the recording anytime before this maximum

function fc = setupRecording(fc,filename,maxtime,curWindow)

codes = messagecodes;

m.parameters = {filename,fc.numsensors,maxtime};
m.command = codes.setuprecording;
sendmessage(fc,m,'setupRecording');
