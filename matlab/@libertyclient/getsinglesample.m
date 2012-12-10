% GETSINGLESAMPLE - get a single sample
% 
% data = getsinglesample(lc)

function data = getsinglesample(lc)

codes = messagecodes;

m.parameters = [];
m.command = codes.LIBERTY_GetSingleSample;
sendmessage(lc,m,'GetSingleSample');
[data,success] = receivemessage(lc);

if success < 0
  error('Error in receiving data');
end
