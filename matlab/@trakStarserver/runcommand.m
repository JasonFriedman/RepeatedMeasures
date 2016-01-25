% RUNCOMMAND - run a command received on the socket
%
% returnValue = runcommand(ls,command,parameters)
%
% parameters should be empty if there are no parameters
% If appopriate, the function will return a value in returnValue,
% otherwise NaN

function [returnValue,changedParameters,changedValues] = runcommand(ts,command,parameters)

codes = messagecodes;
enuminfo = getEnums;
returnValue = NaN;
changedParameters = [];
changedValues = [];

switch(command)
    case {codes.TRAKSTAR_SetHemisphere}
        for sensor=1:ts.numsensors
            handleError(ts,calllib(ts.libstring, 'SetSensorParameter',sensor-1,...
                enuminfo.SENSOR_PARAMETER_TYPE.HEMISPHERE, ...
                int32(parameters), 4));
        end
        thename = 'SetHemisphere';
    case {codes.TRAKSTAR_SetRange}
        handleError(ts,calllib(ts.libstring, 'SetSystemParameter',enuminfo.SYSTEM_PARAMETER_TYPE.MAXIMUM_RANGE,...
            double(parameters), 8));
        thename = 'SetRange';
    otherwise
        error(['Unknown command ' command]);
end
if isdebug(ts)
    fprintf('Sent command %s\n',thename);
end