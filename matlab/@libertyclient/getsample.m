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
  if lc.recordOrientation
      datalength=6;
  else
      datalength=3;
  end
  data = zeros(1,lc.numsensors*datalength+2);
  warning('Error in receiving data in libertyclient/getsample');
end
