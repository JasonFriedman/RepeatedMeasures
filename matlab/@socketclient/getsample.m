% GETSAMPLE - get the last sample recorded
%
% data = getsample(sc)

function data = getsample(sc)

codes = messagecodes;

m.parameters = [];
m.command = codes.getsample;
sendmessage(sc,m,'getsample');
[data,success] = receivemessage(sc);

if success < 0
    error('Error in receiving data');
end
