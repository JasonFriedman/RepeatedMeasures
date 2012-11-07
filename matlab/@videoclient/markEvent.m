% MARKEVENT - tell the server to mark an event
% markEvent(vc,eventNumber)
%
% This replaces the superclass version

function markEvent(vc,eventNumber)

codes = messagecodes;

sendmessage(vc,codes.rvMarkTime,eventNumber,'','markEvent');
