% SETUPRECORDING - set up a recording
% 
% setupRecording(lc,filename,maxtime)
% maxtime is the maximum amount of time (in seconds) that will be captured.
% You can stop the recording anytime before this maximum

function lc = setupRecording(lc,filename,maxtime,curWindow)

codes = messagecodes;

m.parameters = {filename,lc.numsensors,maxtime};
m.command = codes.setuprecording;
sendmessage(lc,m,'setupRecording');
