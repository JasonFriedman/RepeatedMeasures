% INITIALIZEDEVICE - initialize the device (perform any operations necessary to start using the device)
% 
% initializeDevice(sc)

function initializeDevice(sc)

codes = messagecodes;

m.command = codes.initializeDevice;
m.parameters = [];
sendmessage(sc,m,'initializeDevice');
