% TRANSPUTERSHUTDOWNSYSTEM - shutdown the system
%
% TransputerShutdownSystem(oc)

function TransputerShutdownSystem(oc)

codes = messagecodes;

m.command = codes.OPTO_TransputerShutdownSystem;
m.parameters = [];

sendmessage(oc,m,'TransputerShutdownSystem');
