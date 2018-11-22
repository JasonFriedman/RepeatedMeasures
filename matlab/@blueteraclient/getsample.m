% GETSAMPLE - get the last sample recorded
% 
% data = getsample(rc)

function data = getsample(rc)

codes = messagecodes;

m.parameters{1} = rc.numsensors;
m.command = codes.getsample;
sendmessage(rc,m,'getsample');
[data,success] = receivemessage(rc);

if success < 0
  data = zeros(1,rc.numsensors*8+2);
  warning('Error in receiving data in blueteraclient/getsample');
end
