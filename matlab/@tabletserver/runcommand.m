% RUNCOMMAND - run a command received on the socket
%
% returnValue = runcommand(o,command,parameters)
%
% parameters should be empty if there are no parameters
% If appopriate, the function will return a value in returnValue,
% otherwise NaN

function returnValue = runcommand(t,command,parameters)

returnValue = NaN;

switch(command)
    case {t.codes.getbuttons}
        returnValue = getbuttons(t);
    otherwise
        error(['Unknown command ' command]);
end
