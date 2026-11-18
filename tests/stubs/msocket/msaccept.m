% MSACCEPT - stub: simulated servers do not accept connections through this function
function sock = msaccept(varargin)
error('rmtest:msocket','msaccept is not available with the simulated msocket (listen() cannot be run in-process; use rmtestStartServer)');
