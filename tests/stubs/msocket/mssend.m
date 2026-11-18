% MSSEND - stub of msocket's mssend: hands the message to the simulated server
function success = mssend(sock,data)
rmtestServerStep(sock,data);
success = 1;
