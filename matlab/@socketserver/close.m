% CLOSE - close the socket connection
%
% close(s);

function close(s)

msclose(s.socket);
