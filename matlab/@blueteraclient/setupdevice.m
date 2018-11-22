% SETUPDEVICE - setup the device

function rc = setupdevice(rc)

codes = messagecodes;

% First send the hardware addresses
m.parameters = rc.addresses;
m.command = codes.BLUETERA_addresses;
sendmessage(rc,m,'Addresses');

% Initialize the device
m.parameters = [];
m.command = codes.initializeDevice;
sendmessage(rc,m,'InitializeDevice');

% This is slow, so wait 10 seconds for it to finish (9 seconds here, 1 second in next loop)
pause(9);

% Get the states of the sensors
count = 0;
data = 1;
% give up after 15 more seconds
while count<15 && ~all(data==0)
    pause(1);
    count = count+1;
    m.parameters = [];
    m.command = codes.BLUETERA_getSensorStates;
    sendmessage(rc,m,'GetSensorStates');
    [data,success] = receivemessage(rc);
end

if numel(data)==0 || ~all(data==0)
    error(['Error in getting sensor states: sensors returned ' num2str(data)]);
end