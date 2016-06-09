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

    switch(command)
        case {ls.codes.LIBERTY_GetSingleSample}
            returnValue = getsinglesample(ls,ls.numsensors);
            thename = 'GetSingleSample';
        case {ls.codes.LIBERTY_GetUpdateRate}
            rate = getupdaterate(ls);
            if rate==60
                returnValue = 2;
            elseif rate==120
                returnValue = 3;
            elseif rate==240
                returnValue = 4;
            else
                error(['Unknown update rate ' rate]);
            end
            thename = 'GetUpdateRate';
        otherwise
            error(['Unknown command ' command]);
    end
    if isdebug(ls)
        fprintf('Sent command %s\n',thename);
    end
    
