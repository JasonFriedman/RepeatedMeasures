% SETUPRECORDING - set up a recording
% 
% setupRecording(kc,filename,maxtime)
% maxtime is the maximum amount of time (in seconds) that will be captured.
% You can stop the recording anytime before this maximum

function mc = setupRecording(mc,filename,maxtime,curWindow)

codes = messagecodes;

m.parameters = {filename,1,maxtime};
m.command = codes.setuprecording;
sendmessage(mc,m,'setupRecording');
