% TRANSPUTERINITIALIZESYSTEM - initialize the optotrak
%
% TransputerInitializeSystem(oc)
% 
% If this computer is the secondary host (defined when optotrak client is
% created), it will be setup as secondary host, otherwise primary 

function TransputerInitializeSystem(oc)

codes = messagecodes;

m.command = codes.OPTO_TransputerInitializeSystem;
if oc.secondaryhost
  m.parameters = {{'OPTO_SECONDARY_HOST_FLAG'}};
else
  m.parameters = [];
end

sendmessage(oc,m,'TransputerInitialize');
