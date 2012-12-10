% GETSAMPLE - get the last sample recorded
%
% The first two elements contain the x and y, converted to screen
% coordinates (if the maxx / maxy was provided).
% The other elements are not converted
%
% data = getsample(tc)

function data = getsample(tc)

codes = messagecodes;

m.parameters = [];
m.command = codes.getsample;
sendmessage(tc,m,'getsample');
[data,success] = receivemessage(tc);

% convert x and y coordinates to screen (0-1) from tablet coordinates
if numel(data)>0
    data(1) = data(1)./tc.maxx;
    data(2) = data(2)./tc.maxy;
end

if success < 0
    error('Error in receiving data');
end
