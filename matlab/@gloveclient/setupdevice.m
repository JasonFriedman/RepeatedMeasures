% SETUPDEVICE - setup the glove
%
% Send initial commands to get the glove setup

function cgc = setupdevice(cgc)

initializeDevice(cgc);
codes = messagecodes;
m.parameters = [];
m.command = codes.isServerRunning;
sendmessage(cgc,m,'isServerRunning');
[response,success] = receivemessage(cgc);
if success < 0
    error('Error in Connecting to the Server');
end

m.parameters = cgc.getRawData;
m.command = codes.GLOVE_getRawData;
sendmessage(cgc,m,'getRawData');
fprintf('Sent message of getRawData\n');

