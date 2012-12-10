% CLOSE - close the socket
% 
% close(sc)

function close(sc)

codes = messagecodes;

m.command = codes.closesocket;
m.parameters = [];
sendmessage(sc,m,'closesocket');
