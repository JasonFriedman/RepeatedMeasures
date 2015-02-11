% RUNCOMMAND - run a command received on the socket
%
% returnValue = runcommand(o,command,parameters)
%
% parameters should be empty if there are no parameters
% If appopriate, the function will return a value in returnValue,
% otherwise NaN

function [returnValue,changedParameters,changedValues] = runcommand(cgs,command,parameters)

changedParameters = [];
changedValues = [];
returnValue = NaN;
switch(command)
    case {cgs.codes.isServerRunning}
        if isdebug(cgs)
            fprintf('Checking the Server Connection Status  \n');
        end
        returnValue = cgs.isConnected;
    case {cgs.codes.GLOVE_getRawData}
        changedParameters{1} = 'getRawData';
        changedValues{1} = parameters;
        if isdebug(cgs)
            fprintf('Set getRawData to %d\n',changedValues{1});
        end
end