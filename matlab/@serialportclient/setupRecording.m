% SETUPRECORDING - set up a recording
% 
% setupRecording(sc,filename,maxtime)
% maxtime is the maximum amount of time (in seconds) that will be captured.
% You can stop the recording anytime before this maximum

function sc = setupRecording(sc,filename,maxtime,curWindow)

codes = messagecodes;

m.parameters = {filename,1,maxtime};
m.command = codes.setuprecording;
sendmessage(sc,m,'setupRecording');
