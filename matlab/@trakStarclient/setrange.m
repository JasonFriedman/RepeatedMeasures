% SETRANGE - set the sensing range
% 
% Can be: 36.0, 72.0 or 144.0 (in inches)
% setrange(tc)

function setrange(tc)

codes = messagecodes;

if ~any(tc.range==[36 72 144])
    error('Range for trakStar must be 36,72 or 144');
end

m.parameters = tc.range;
m.command = codes.TRAKSTAR_SetRange;

sendmessage(tc,m,'SetRange');
