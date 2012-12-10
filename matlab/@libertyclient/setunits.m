% SETUNITS - set the units to cm or inches
% 
% setunits(l,units)
% 0 = inches
% 1 = cm

function setunits(lc,units)

codes = messagecodes;

m.command = codes.LIBERTY_SetUnits;
m.parameters = units;

sendmessage(lc,m,'SetUnits');
