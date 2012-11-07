% SETUPDEVICE - setup the optotrak
%
% Send initial commands to get optotrak setup

function setupdevice(oc)

% Only check if camera file exists if the server is running on the
% same computer.
today = ['Aligned' datestr(now,'yyyymmdd')];

if strcmp(get(oc,'server'),'localhost') || strcmp(get(oc,'server'),'127.0.0.1')
    
    % First check that the camera file for today exists
    realtime_dir = 'c:\ndigital\realtime\';
    
    multiple = [realtime_dir today '_1.cam'];
    if exist(multiple,'file')
        error(['There are multiple optotrak calibration ' ...
            'files for today (in c:\ndigital\realtime).' ...
            'Please leave only one.']);
    end
    today_cam = [realtime_dir today '.cam'];
    if ~exist(today_cam,'file')
        error(['Optotrak calibration has not been performed today. Please '...
            'first run the calibration using First Principles']);
    end
end

e = get(oc,'experiment');

if ~oc.secondaryhost
    % Only need TransputerLoadSystem when primary host
    TransputerLoadSystem(oc,'system');
end
pause(4);
writetolog(e,'Connected to optotrak client');
TransputerInitializeSystem(oc);
writetolog(e,'TransputerInitializeSystem');
pause(4);
OptotrakLoadCameraParameters(oc,today);
writetolog(e,'OptotrakLoadCameraParameters');
pause(4);
if ~oc.secondaryhost
    %Set collection parameters (only when primary host)
    OptotrakSetupCollection(oc,oc.collectionParameters);
end
OptotrakPrintStatus(oc);
writetolog(e,'OptotrakPrintStatus');
