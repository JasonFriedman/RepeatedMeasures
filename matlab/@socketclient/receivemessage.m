% RECEIVEMESSAGE - receive a matlab variable over the socket
% received = receivemessage(sc)

function [received,success] = receivemessage(sc)

[received,success] = msrecv(sc.sock,10);

if sc.debug
    fprintf('Received response on socket, returned %d\n',success);
end
