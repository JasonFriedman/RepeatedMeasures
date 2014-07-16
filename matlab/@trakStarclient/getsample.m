% GETSAMPLE - get the last sample recorded
% 
% data = getsample(tc)

function data = getsample(tc)

codes = messagecodes;

m.parameters{1} = tc.numsensors;
m.command = codes.getsample;
sendmessage(tc,m,'getsample');
[data,success] = receivemessage(tc);

if success < 0
  data = zeros(1,tc.numsensors*8+2);
  warning('Error in receiving data in trakStarclient/getsample');
end
