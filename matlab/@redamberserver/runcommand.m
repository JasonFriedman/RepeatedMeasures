% RUNCOMMAND - run a command received on the socket
%
% returnValue = runcommand(ls,command,parameters)
%
% parameters should be empty if there are no parameters
% If appopriate, the function will return a value in returnValue,
% otherwise NaN

function [returnValue,changedParameters,changedValues] = runcommand(ls,command,parameters)

changedParameters = [];
changedValues = [];
returnValue = NaN;

codes = messagecodes;

switch(command)
    case {codes.REDAMBER_getSensorStates}
        [numgems,states] = redamberMex(2);
        returnValue = states;
        if isdebug(ls)
            fprintf('Received request for sensor stages, returning:\n');
            states
        end
    case {codes.REDAMBER_addresses}
        changedParameters = {'addresses'};
        changedValues = {parameters};
        if isdebug(ls)
            fprintf('Received addresses:\n');
            parameters
        end
    otherwise
        error(['Unknown command ' command]);
end