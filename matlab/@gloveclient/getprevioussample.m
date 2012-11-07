% GETPREVIOUSSAMPLE - get an earlier sample
% 
% data = getprevioussample(gc,timelag)

function data = getprevioussample(gc,timelag)

codes = messagecodes;

m.parameters{1} = timelag;
m.command = codes.getprevioussample;
sendmessage(gc,m,'getprevioussample');
[data,success] = receivemessage(gc);

if success < 0
  %error('Error in receiving previous data');
  data = [];
end
