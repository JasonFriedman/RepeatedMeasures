% RUNCOMMAND - run a command received on the socket
%
% returnValue = runcommand(ls,command,parameters)
%
% parameters should be empty if there are no parameters
% If appopriate, the function will return a value in returnValue,
% otherwise NaN

function returnValue = runcommand(ls,command,parameters)

returnValue = NaN;
dontsend = 0;

switch(command)
    case {ls.codes.LIBERTY_SetMode}
        % put into binary or ASCII mode
        thecommand = sprintf('F%d',parameters);
        thename = 'SetMode';
    case {ls.codes.LIBERTY_SetUnits}
        % set units to inches (0) or cm (1)
        thecommand = sprintf('U%d',parameters);
        thename = 'SetUnits';
    case {ls.codes.LIBERTY_SetHemisphere}
        % Set the hemisphere
        thecommand = sprintf('H%d,%d,%d,%d',parameters{1},parameters{2},parameters{3},parameters{4});
        thename = 'SetHemisphere';
    case {ls.codes.LIBERTY_SetSampleRate}
        % set sample rate (3=120Hz, 4=240Hz)
        thecommand = sprintf('R%d',parameters);
        thename = 'SetSampleRate';
    case {ls.codes.LIBERTY_ResetFrameCount}
        % Reset the frame count
        thecommand = 'Q1';
        thename = 'ResetFrameCount';
    case {ls.codes.LIBERTY_SetOutputFormat}
        % Reset the frame count
        if parameters{2}==1
            thecommand = sprintf('O%d,3,9',parameters{1});
        elseif parameters{2}==2
            thecommand = sprintf('O%d,3,5,9',parameters{1});
        else
            error(['Unknown output format ' parameters{2}]);
        end
        thename = 'SetOutputFormat';
    case {ls.codes.LIBERTY_GetSingleSample}
        returnValue = getsinglesample(ls,ls.numsensors);
        dontsend = 1;
        if isdebug(ls)
            fprintf('GetSingleSample\n');
        end
    case {ls.codes.LIBERTY_GetUpdateRate}
        returnValue = getupdaterate(ls);
        dontsend = 1;
        if isdebug(ls)
            fprintf('GetUpdateRate, returned %d\n',returnValue);
        end
    case {ls.codes.LIBERTY_AlignmentReferenceFrame}
        % clear the previous reference frame
        thecommand = sprintf('%c%d',18,parameters{1}); % 18 is control-R (maybe)
        IOPort('Write',ls.s,[thecommand char(13)]);
        thecommand = sprintf('A%d,%d,%d,%d,%d,%d,%d,%d,%d,%d',parameters{1},parameters{2}(1),parameters{2}(2),parameters{2}(3),...
            parameters{2}(4),parameters{2}(5),parameters{2}(6),parameters{2}(7),parameters{2}(8),parameters{2}(9));
        thename = 'AlignmentReferenceFrame';
    otherwise
        error(['Unknown command ' command]);
end

if ~dontsend
    IOPort('Write',ls.s,[thecommand char(13)]);
    if isdebug(ls)
        fprintf('%s: %s\n',thename,thecommand);
    end
end


% Check if there is anything in the buffer (there should not be!)
pause(0.1);
if IOPort('BytesAvailable',ls.s)
    inBuffer = IOPort('Read',ls.s,1,IOPort('BytesAvailable',ls.s));
    error(['Error: ' char(inBuffer)]);
end
