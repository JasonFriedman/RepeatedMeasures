% SETMODE - set the mode to binary or ASCII
% 
% setmode(l,mode)
% 0 = ASCII
% 1 = binary

function setmode(lc,mode)

codes = messagecodes;

m.command = codes.LIBERTY_SetMode;
m.parameters = mode;

sendmessage(lc,m,'SetMode');
