% GETBUTTONS - get the current state of the buttons
%
% Each bit in the integer describes state of one button. Mapping is device specific:
% E.g., bitget(button, 3) would tell you the state of the 3rd button.
%
% buttons = getbuttons(tc)

function buttons = getbuttons(tc)

codes = messagecodes;

m.parameters = [];
m.command = codes.getbuttons;
sendmessage(tc,m,'getbuttons');
[buttons,success] = receivemessage(tc);

if success < 0
    error('Error in receiving data');
end
