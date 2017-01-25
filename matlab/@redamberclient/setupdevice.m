% SETUPDEVICE - setup the device

function rc = setupdevice(rc)

codes = messagecodes;

% First send the hardware addresses
m.parameters = rc.addresses;
m.command = codes.REDAMBER_addresses;
sendmessage(rc,m,'Addresses');

% Initialize the device
m.parameters = [];
m.command = codes.initializeDevice;
sendmessage(rc,m,'InitializeDevice');

% This is slow, so wait 10 seconds for it to finish
pause(10);

% Get the states of the sensors
m.parameters = [];
m.command = codes.REDAMBER_getSensorStates;
sendmessage(rc,m,'GetSensorStates');
[data,success] = receivemessage(rc);

if numel(data)==0 || ~all(data==0)
    error('Error in getting sensor states');
end