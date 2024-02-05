% CLOSE - close the socket
% 
% close(dc)

function close(dc)

codes = messagecodes;

m.command = codes.closesocket;
m.parameters = [];
sendmessage(dc,m,'closesocket');

