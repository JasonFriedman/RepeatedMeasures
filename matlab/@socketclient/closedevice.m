% CLOSEDEVICE - close the device (perform any operations necessary to shutdown the device)
% 
% closeDevice(sc)

function closedevice(sc)

codes = messagecodes;

m.command = codes.closeDevice;
m.parameters = [];
sendmessage(sc,m,'closedevice');
