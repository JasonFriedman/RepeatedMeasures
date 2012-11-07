% CLOSESOCKET - close the socket
%
% closeSocket(vc)

function closeSocket(vc)

codes = messagecodes;
sendmessage(vc,codes.rvCloseSocket,'','','closeSocket');
