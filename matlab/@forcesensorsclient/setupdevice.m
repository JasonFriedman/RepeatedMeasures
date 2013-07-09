% SETUPDEVICE - set up the device

function setupdevice(fc)

% send the gains and offsets to the server
codes = messagecodes;

parameters(1,:) = fc.offsets;
parameters(2,:) = fc.gains;

m.command = codes.FORCESENSORS_setParameters;
m.parameters = parameters;
sendmessage(fc,m,'setParameters');

