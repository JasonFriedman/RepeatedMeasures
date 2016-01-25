% SETUPDEVICE - setup the device

function tc = setupdevice(tc)

codes = messagecodes;

% Initialize the device
m.parameters = [];
m.command = codes.initializeDevice;
sendmessage(tc,m,'InitializeDevice');

% This is slow, so wait 20 seconds for it to finish
pause(20);

% Set the hemisphere
sethemisphere(tc);
pause(0.5);
setrange(tc);
pause(0.5);