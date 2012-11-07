% GETSAMPLE - get the last sample recorded
% 
% The first two elements contain the x and y, converted to screen
% coordinates (if the maxx / maxy was provided). 
% The other elements are not converted
% 
% data = getsample(mc)

function data = getsample(mc)

codes = messagecodes;

m.parameters = [];
m.command = codes.getsample;
sendmessage(mc,m,'getsample');
[data,success] = receivemessage(mc);

% convert x and y coordinates to screen (0-1) from mouse coordinates
if numel(data)>0
    data(1) = data(1)./mc.maxx;
    data(2) = 1 - (data(2)./mc.maxy);
end

if success < 0
  error('Error in receiving data');
end
