% GETSAMPLE - get the last sample recorded
% 
% The other elements are not converted
% 
% data = getsample(ftc)

function data = getsample(ftc)

codes = messagecodes;

m.parameters = [];
m.command = codes.getsample;
sendmessage(ftc,m,'getsample');
[data,success] = receivemessage(ftc);

if success < 0
  error('Error in receiving data');
end
