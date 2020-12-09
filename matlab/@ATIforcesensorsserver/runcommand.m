% RUNCOMMAND - run a command received on the socket
%
% [returnValue,changedParameters,changedValues] = runcommand(f,command,parameters)
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
        v.sendTelnetCommand('CAL',0);
        pause(1);
        response = v.readTelnetData(1).toCharArray'
        % Need to extract the counts/N and counts/N-m to convert the data
        start = strfind(response,'Force:') + 6;
        theend = strfind(response,'counts/N')-1;
        counts_per_N = str2double(strrep(response(start:theend),' ',''));
        
        start = strfind(response,'Torque:') + 7;
        theend = strfind(response,'counts/N-m')-1;
        counts_per_Nm = str2double(strrep(response(start:theend),' ',''));
        
        changedParameters = {'counts_per_N','counts_per_Nm'};
        changedValues = {counts_per_N,counts_per_Nm};
        
        % Set to receive force / torque (and not Gage data)
        % This sets the active transducer 
        v.sendTelnetCommand('TRANS 3',0);
        pause(1);
        v.readTelnetData(1)
        
        v.sendTelnetCommand('CAL MULT ON',0);
        pause(1);
        v.readTelnetData(1)
        
        v.sendTelnetCommand('NET UDPACT DROP',0);
        pause(1);
        v.readTelnetData(1)
        
    case {f.codes.ATI_bias}
        % Send command to bias (zero) the sensors
        for sensor=f.channels
            v.sendTelnetCommand(sprintf('BIAS %d ON',sensor),0);
        end
        pause(0.1);
        v.readTelnetData(1)
        
    otherwise
        error(['Unknown command ' command]);
end
