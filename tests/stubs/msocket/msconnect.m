% MSCONNECT - stub of msocket's msconnect: connects to an in-process simulated server
% (registered with rmtestStartServer). Returns -1 if there is no server on that port.
function sock = msconnect(hostname,port) %#ok<INUSL>
w = rmtestWorld;
sock = -1;
for k=1:numel(w.servers)
    if w.servers{k}.port == port
        sock = k;
        % the server acknowledges the connection
        ack.accepted = 1;
        w.servers{k}.queue = {ack};
        w.servers{k}.connected = 1;
        rmtestWorld(w);
        return;
    end
end
