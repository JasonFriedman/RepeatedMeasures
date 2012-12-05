% SETUPRECORDING - set up a recording
% 
% setupRecording(sc,filename,maxtime,windowNum)
% maxtime is the maximum amount of time (in seconds) that will be captured.
% You can stop the recording anytime before this maximum
%
% The windowNum parameter is ignored here, but it can be used by a
% subclass (e.g. for tablet recording)

function gfc = setupRecording(gfc,filename,maxtime,windowNum)

gfc.glove = setupRecording(gfc.glove,filename,maxtime,windowNum);
gfc.tracker = setupRecording(gfc.tracker,filename,maxtime,windowNum);
