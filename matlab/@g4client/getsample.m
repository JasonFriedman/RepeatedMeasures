% GETSAMPLE - get the last sample recorded
% 
% data = getsample(lc)

function data = getsample(lc)

codes = messagecodes;

m.parameters{1} = lc.numsensors;
m.command = codes.getsample;
sendmessage(lc,m,'getsample');
[data,success] = receivemessage(lc);

if success < 0
  data = zeros(1,lc.numsensors*6+2);
  warning('Error in receiving data in g4client/getsample');
end
