% MARKEVENT - tell the server to mark an event
% markEvent(sc,eventNumber)

function markEvent(sc,eventNumber)

codes = messagecodes;

m.parameters = eventNumber;
m.command = codes.markEvent;
sendmessage(sc,m,'markEvent');
