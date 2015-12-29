% RUNCOMMAND - run a command received on the socket
%
% returnValue = runcommand(o,command,parameters)
%
% parameters should be empty if there are no parameters
% If appopriate, the function will return a value in returnValue,
% otherwise NaN

function [returnValue,changedParameters,changedValues] = runcommand(t,command,parameters)

changedParameters = [];
changedValues = [];
returnValue = NaN;

switch(command)
    case {t.codes.getbuttons}
        returnValue = getbuttons(t);
    case {t.codes.TABLET_attachTablet}
        WinTabMex(0,parameters{1});
    case {t.codes.TABLET_closeInterface}
        % Close the interface (so it can be reopened next time)
        WinTabMex(1);
    otherwise
        error(['Unknown command ' command]);      
end
