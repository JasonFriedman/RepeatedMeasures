% SENDMESSAGE - send a message to the port
% sendmessage(S,command)

function sendmessage(p,command)

putvalue(p.DIO,command);