% TRANSPUTERLOADSYSTEM - load the parameters from a file 
%
% TransputerInitializeSystem(oc,filename)

function TransputerLoadSystem(oc,filename)

codes = messagecodes;

m.command = codes.OPTO_TransputerLoadSystem;
m.parameters = filename;

sendmessage(oc,m,'TransputerLoadSystem');
