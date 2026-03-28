% SETUPDEVICE - setup the device

function sc = setupdevice(sc)

codes = messagecodes;

% Set the number of characters
m.parameters = sc.numcharacters;
m.command = codes.SERIALPORT_setNumberCharacters;
sendmessage(sc,m,'SERIALPORT_setNumberCharacters');