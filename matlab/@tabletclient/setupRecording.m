% SETUPRECORDING - set up a recording
% 
% setupRecording(tc,filename,maxtime,windowNum)
% maxtime is the maximum amount of time (in seconds) that will be captured.
% You can stop the recording anytime before this maximum
% windowNum is the number of the psychtoolbox window (so that tablet
% software can attach to it)

function tc = setupRecording(tc,filename,maxtime,windowNum)

codes = messagecodes;

m.parameters = {filename,windowNum,maxtime};
m.command = codes.setuprecording;
sendmessage(tc,m,'setupRecording');
