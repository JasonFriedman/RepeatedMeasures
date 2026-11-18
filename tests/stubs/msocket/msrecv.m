% MSRECV - stub of msocket's msrecv: returns the next reply of the simulated server
function [data,success] = msrecv(sock,timeout) %#ok<INUSD>
w = rmtestWorld;
if sock<1 || sock>numel(w.servers) || isempty(w.servers{sock}.queue)
    data = [];
    success = -1;
    return;
end
data = w.servers{sock}.queue{1};
w.servers{sock}.queue(1) = [];
rmtestWorld(w);
success = 1;
