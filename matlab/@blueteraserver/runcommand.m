% RUNCOMMAND - run a command received on the socket
%
% returnValue = runcommand(rs,command,parameters)
%
% parameters should be empty if there are no parameters
% If appopriate, the function will return a value in returnValue,
% otherwise NaN

function [returnValue,changedParameters,changedValues] = runcommand(rs,command,parameters)

changedParameters = [];
changedValues = [];
returnValue = NaN;

codes = messagecodes;

switch(command)
    case {codes.BLUETERA_getSensorStates}
        [numsensors,states] = blueTeraMex(2);
        returnValue = states;
        if isdebug(rs)
            fprintf('Received request for sensor stages, returning:\n');
            states
        end
    case {codes.BLUETERA_addresses}
        changedParameters = {'addresses'};
        changedValues = {parameters};
        if isdebug(rs)
            fprintf('Received addresses:\n');
            parameters
        end
        if numel(parameters) ~= rs.numsensors
            error('Number of addresses sent does not match the number of sensors specified for redamberserver');
        end
    otherwise
        error(['Unknown command ' command]);
end