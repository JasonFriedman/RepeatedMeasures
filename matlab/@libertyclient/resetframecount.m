% RESETFRAMECOUNT - reset the frame coutn
% 
% resetframecount(lc)

function resetframecount(lc)

codes = messagecodes;

m.command = codes.LIBERTY_ResetFrameCount;
m.parameters = [];

sendmessage(lc,m,'ResetFrameCount');
