% MSLISTEN - stub of msocket's mslisten for simulated (in-process) device servers
% Returns a fake socket number; the server is attached with rmtestStartServer.
function sock = mslisten(port)
sock = -abs(port); % negative numbers = listening sockets of simulated servers
