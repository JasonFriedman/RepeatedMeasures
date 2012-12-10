% RUNCOMMAND - run a command received on the socket
%
% returnValue = runcommand(o,command,parameters)
%
% parameters should be empty if there are no parameters
% If appopriate, the function will return a value in returnValue,
% otherwise NaN

function returnValue = runcommand(o,command,parameters)

returnValue = NaN;

switch(command)
    case {o.codes.OPTO_TransputerLoadSystem}
        if isdebug(o)
            fprintf('You should not be running TransputerLoadSystem if this is a secondary host');
        end
        optotrak('TransputerLoadSystem',parameters);
        
    case {o.codes.OPTO_TransputerInitializeSystem}
        %Initialize the transputer system.
        if isempty(parameters)
            optotrak('TransputerInitializeSystem');
        else
            optotrak('TransputerInitializeSystem',parameters{1});
        end
        if isdebug(o)
            fprintf('TransputerInitializeSystem\n');
        end
    case {o.codes.OPTO_OptotrakLoadCameraParameters}
        % Check that the camera file exists. This check is also done
        % in the client (when the server is on the same machine).
        
        realtime_dir = 'c:\ndigital\realtime\';
        
        multiple = [realtime_dir parameters '_1.cam'];
        if exist(multiple,'file')
            error(['There are multiple optotrak calibration ' ...
                'files for today (in c:\ndigital\realtime).' ...
                'Please leave only one.']);
        end
        today_cam = [realtime_dir parameters '.cam'];
        if ~exist(today_cam,'file')
            error(['Optotrak calibration has not been performed today. Please '...
                'first run the calibration using First Principles']);
        end
        
        %Load the camera parameters
        optotrak('OptotrakLoadCameraParameters',parameters);
        if isdebug(o)
            fprintf('OptotrakLoadCameraParameters\n');
        end
    case {o.codes.OPTO_OptotrakSetupCollection}
        optotrak('OptotrakSetupCollection',parameters);
        if isdebug(o)
            fprintf('OptotrakSetupCollection\n');
        end
    case {o.codes.OPTO_OptotrakPrintStatus}
        %Request and print the OPTOTRAK status.
        optotrak('OptotrakPrintStatus');
        if isdebug(o)
            fprintf('OptotrakPrintStatus\n');
        end
    case {o.codes.OPTO_OptotrakActivateMarkers}
        % Activate the markers
        optotrak('OptotrakActivateMarkers');
        if isdebug(o)
            fprintf('Activated the markers\n');
        end
    case {o.codes.OPTO_OptotrakDeActivateMarkers}
        % Deactivate the markers
        optotrak('OptotrakDeActivateMarkers');
        if isdebug(o)
            fprintf('DeActivated the markers\n');
        end
    case {o.codes.OPTO_DataGetLatest3D}
        % Get the latest 3D data
        returnValue = optotrak('DataGetLatest3D',parameters);
        if isdebug(o)
            fprintf('Got a frame of data\n');
        end
    case {o.codes.OPTO_TransputerShutdownSystem}
        %Shutdown the transputer message passing system.
        optotrak('TransputerShutdownSystem');
        if isdebug(o)
            fprintf('TransputerShutdownSystem\n');
        end
    otherwise
        error(['Unknown command ' command]);
end
