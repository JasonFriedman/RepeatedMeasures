% GETSAMPLE - get the last sample recorded
%
% data = getsample(oc)

function data = getsample(oc)

codes = messagecodes;

m.parameters{1} = oc.numbermarkers;
m.command = codes.getsample;
sendmessage(oc,m,'getsample');
[data,success] = receivemessage(oc);

if success < 0
    error('Error in receiving data');
end
