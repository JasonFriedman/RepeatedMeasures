% SETUPRECORDING - set up a recording
% 
% setupRecording(sc,filename,maxtime,windowNum)
% maxtime is the maximum amount of time (in seconds) that will be captured.
% You can stop the recording anytime before this maximum
%
% The windowNum parameter is ignored here

function gc = setupRecording(gc,filename,maxtime,windowNum)

codes = messagecodes;

m.parameters = {filename,22,maxtime};
m.command = codes.setuprecording;
sendmessage(gc,m,'setupRecording');
