% RUNCOMMAND - run a command received on the socket
%
% returnValue = runcommand(gs,command,parameters)
%
% parameters should be empty if there are no parameters
% If appopriate, the function will return a value in returnValue,
% otherwise NaN

function [returnValue,changedParameters,changedValues] = runcommand(gs,command,parameters)

codes = messagecodes;
returnValue = NaN;
changedParameters = {};
changedValues = [];

switch(command)
    case {codes.GOPRO_setuprecording}
        changedParameters{1} = 'lastFilename';
        changedValues{1} = parameters{1};
        
    case {codes.GOPRO_startrecording}
        startRecording(gs);
        changedParameters{1} = 'recording';
        changedValues{1} = 1;
        
    case {codes.GOPRO_stoprecording}
        stopRecording(gs);
        changedParameters{1} = 'recording';
        changedValues{1} = 0;

    case {codes.GOPRO_savefile}
        savefile(gs);
        returnValue = 1;  % so it will stop waiting
        
    otherwise
        error(['Unknown command ' command]);
end
