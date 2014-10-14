% SENDMESSAGE - send a message to the port
% sendmessage(S,command)

function sendmessage(S,command)

[nwritten,when,errmsg] = IOPort('Write',S.s,command);
