% RUNCOMMAND - run a command received on the socket
%
% returnValue = runcommand(o,command,parameters)
%
% parameters should be empty if there are no parameters
% If appopriate, the function will return a value in returnValue,
% otherwise NaN

function [returnValue,changedParameters,changedValues] = runcommand(d,command,parameters)

changedParameters = [];
changedValues = [];
returnValue = NaN;

codes = messagecodes;

switch(command)
    case {codes.ARDUINO_sendTrigger}
        writeDigitalPin(d.arduino, d.outputPins{1}, parameters(1));
end