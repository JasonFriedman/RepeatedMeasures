% GETSAMPLE - get the last sample recorded
% 
% The other elements are not converted
% 
% data = getsample(gc)

function data = getsample(gc)

codes = messagecodes;

m.parameters = [];
m.command = codes.getsample;
sendmessage(gc,m,'getsample');
[data,success] = receivemessage(gc);

if success < 0
  error('Error in receiving data'); %data = NaN;
end
