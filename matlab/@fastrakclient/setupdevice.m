% SETUPDEVICE - setup the optotrak
%
% Send initial commands to get optotrak setup

function setupdevice(ftc)


initializeDevice(ftc);
codes = messagecodes;
m.parameters = [];
m.command = codes.isServerRunning;
sendmessage(ftc,m,'isServerRunning');
[response,success] = receivemessage(ftc);
if response < 1
    error('Error in Connecting to the Server');
end


