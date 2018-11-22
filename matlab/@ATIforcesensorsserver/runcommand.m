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

v = f.v;

switch(command)
    case {f.codes.ATI_setSampleRate}
        %Initialize the transputer system.
        v.sendTelnetCommand(sprintf('RATE %d 1',parameters(1)),0);
        pause(1);
        v.readTelnetData(1)

        if isdebug(f)
            fprintf('ATI_SetSampleRate\n');
        end
        
    case {f.codes.ATI_setupRecordings}
        % Set to receive force / torque
        v.sendTelnetCommand('TRANS 3',0);
        pause(1);
        v.readTelnetData(1)
        v.sendTelnetCommand('CAL MULT ON',0);
        pause(1);
        v.readTelnetData(1)
        
        v.sendTelnetCommand('NET UDPACT DROP',0);
        pause(1);
        v.readTelnetData(1)

    otherwise
        error(['Unknown command ' command]);
end
