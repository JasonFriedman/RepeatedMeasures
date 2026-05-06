% SENDMESSAGE - send a message to the port
% sendmessage(S,command)

function sendmessage(p,command)
calllib(p.lib,'Out32',p.portaddress,command);