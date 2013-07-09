% RUNCOMMAND - run a command received on the socket
%
% returnValue = runcommand(f,command,parameters)
%
% parameters should be empty if there are no parameters
% If appopriate, the function will return a value in returnValue,
% otherwise NaN

function [returnValue,changedParameters,changedValues] = runcommand(f,command,parameters)

changedParameters = [];
changedValues = [];
returnValue = NaN;

switch(command)
    case {f.codes.FORCESENSORS_setParameters}
        changedParameters{1} = 'parameters';
        changedValues{1} = parameters;
        fprintf('Setting parameters to \n');
        changedValues{1}
    case {f.codes.FORCESENSORS_getParameters}
        returnValue = f.parameters;
    otherwise
        error(['Unknown command ' command]);
end
