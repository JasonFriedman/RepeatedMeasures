% GETUPDATERATE - get the update rate
%
% This is a useful test to see if the liberty is awake and responding
% 
% rate = getupdaterate(lc)

function rate = getupdaterate(lc)

codes = messagecodes;

m.command = codes.LIBERTY_GetUpdateRate;
m.parameters = [];

sendmessage(lc,m,'GetUpdateRate');

rawrate = receivemessage(lc);

if rawrate==3
    rate = 120;
elseif rawrate==4
    rate = 240;
else
    error(['Unknown rate: ' num2str(rawrate)]);
end
