% RUNCOMMAND - run a command received on the socket
%
% returnValue = runcommand(o,command,parameters)
%
% parameters should be empty if there are no parameters
% If appopriate, the function will return a value in returnValue,
% otherwise NaN

function [returnValue,changedParameters,changedValues] = runcommand(s,command,parameters)

changedParameters = [];
changedValues = [];
returnValue = NaN;

codes = messagecodes;

switch(command)
    case {codes.SERIALPORT_sendTrigger}
        % 0-9 are sent as is (but as characters)
        % 10-16 are sent as the letter a-g
        % 20 is reset ('r')
        if parameters==20
            toSend = 'r';
        elseif parameters>=0 && parameters<=9
            toSend = char(parameters+'0');
        elseif parameters >=10 && parameters <=16
            toSend = char(parameters+'a'-10);
        else
            error('Don''t know how to send trigger %d',parameters);
        end
        
        sendmessage(s.s,toSend);
        fprintf('Sent trigger %c\n',toSend);
    otherwise
        error(['Unknown command ' command]);      
end
