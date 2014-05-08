% SENDMESSAGE - send a message to the tactor
% sendmessage(t,command)

function sendmessage(t,command)

if t.connectionType==1
    [nwritten,when,errmsg] = IOPort('Write',t.s,command);
elseif t.connectionType==2
    fwrite(t.s,command,'uint8');
end
