% SETUPRECORDING - set up a recording
% 
% setupRecording(oc,filename,maxtime)
% maxtime is the maximum amount of time (in seconds) that will be captured.
% You can stop the recording anytime before this maximum

function oc = setupRecording(oc,filename,maxtime,curWindow)

codes = messagecodes;

m.parameters = {filename,oc.numbermarkers,maxtime};
m.command = codes.setuprecording;
sendmessage(oc,m,'setupRecording');
