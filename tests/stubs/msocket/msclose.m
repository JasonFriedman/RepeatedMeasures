% MSCLOSE - stub of msocket's msclose
function msclose(sock)
w = rmtestWorld;
if sock>=1 && sock<=numel(w.servers)
    w.servers{sock}.connected = 0;
    rmtestWorld(w);
end
