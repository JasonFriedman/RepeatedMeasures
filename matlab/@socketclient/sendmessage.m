% SENDMESSAGE - send a matlab variable over the socket
% sendmessage(sc,m,name)
% m is the matlab variable to send. It should be a struct with 2 fields:
% m.command and m.parameters
% name is the name of the message (only needed if in debug mode)

function sendmessage(sc,m,name)

success = mssend(sc.sock,m);

if sc.debug
  fprintf('Sent %s, returned %d\n',name,success);
end
