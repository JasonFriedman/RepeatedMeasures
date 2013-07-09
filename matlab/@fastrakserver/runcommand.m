% RUNCOMMAND - run a command received on the socket
%
% returnValue = runcommand(o,command,parameters)
%
% parameters should be empty if there are no parameters
% If appopriate, the function will return a value in returnValue,
% otherwise NaN

function [returnValue,changedParameters,changedValues] = runcommand(fts,command,parameters)

changedParameters = [];
changedValues = [];
returnValue = NaN;
switch(command)
    case {fts.codes.isServerRunning}
        if isdebug(fts)
            fprintf('Checking the Server Connection Status  ');
        end
        returnValue = fts.isConnected;
end