% SETUPDEVICE - setup the glove
%
% Send initial commands to get the glove setup

function setupdevice(cgc)

initializeDevice(cgc);
codes = messagecodes;
m.parameters = [];
m.command = codes.isServerRunning;
sendmessage(cgc,m,'isServerRunning');
[response,success] = receivemessage(cgc);
if response < 1
    error('Error in Connecting to the Server');
end


