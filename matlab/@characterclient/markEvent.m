% MARKEVENT - tell the server to mark an event
% markEvent(sc,eventNumber)

function markEvent(cc,eventNumber)

codes = messagecodes;

mssendraw(cc.sock,[uint8(codes.markEvent) uint8(eventNumber)]);
fprintf('Sent event marker %d\n',eventNumber);
