% CLOSE - close the socket
%
% close(oc)

function close(oc)

codes = messagecodes;

m.command = codes.closesocket;
m.parameters = [];
sendmessage(oc,m,'closesocket');

