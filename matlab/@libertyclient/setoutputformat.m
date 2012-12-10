% SETOUTPUTFORMAT - set the output format
% 
% setoutputformat(l,sensor)
%
% The output format depends on whether lc.recordOrientation is 0 (just
% positions) or 1 (positions and orientations)

function setoutputformat(lc,sensor)

if lc.recordOrientation==1
    format = 2;
else
    format = 1;
end

codes = messagecodes;

m.command = codes.LIBERTY_SetOutputFormat;
m.parameters{1} = sensor;
m.parameters{2} = format;

sendmessage(lc,m,'SetOutputFormat');
