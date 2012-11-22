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
  error('Error in receiving data');
end
