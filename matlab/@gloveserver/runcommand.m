% RUNCOMMAND - run a command received on the socket
%
% returnValue = runcommand(o,command,parameters)
%
% parameters should be empty if there are no parameters
% If appopriate, the function will return a value in returnValue,
% otherwise NaN

function returnValue = runcommand(cgs,command,parameters)

returnValue = NaN;
switch(command)
    case {cgs.codes.isServerRunning}
        if isdebug(cgs)
            fprintf('Checking the Server Connection Status  ');
        end
        returnValue = cgs.isConnected;
end