% STARTSAMPLINGWITHOUTRECORDING - activate the markers, sample but don't record 
%
% The last frame only is stored in memory until the recording is stopped
% 
% startSamplingWithoutRecording(oc,thistrial,experimentdata)

function thistrial = startSamplingWithoutRecording(oc,thistrial,experimentdata)

OptotrakActivateMarkers(oc);

codes = messagecodes;

m.parameters = oc.numbermarkers;
m.command = codes.startwithoutrecord;
sendmessage(oc,m,'startWithoutRecord');
