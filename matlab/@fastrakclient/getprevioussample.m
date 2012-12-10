% GETSAMPLE - get the last sample recorded
% 
% The other elements are not converted
% 
% data = getsample(ftc)

function data = getprevioussample(ftc,timelag)

codes = messagecodes;

m.parameters{1} = timelag;
m.command = codes.getprevioussample;
%m.timelag = timelag;
sendmessage(ftc,m,'getprevioussample');
[data,success] = receivemessage(ftc);

if success < 0
    data = [];
  %error('Error in receiving previous data');
end
