% READBUTTON - read the value of the centre (white) button

function pressed = readButton(t)

codes = messagecodes;

m.parameters = [];
m.command = codes.getsample;
sendmessage(t,m,'getsample');

result = receivemessage(t);

if isempty(result)
    pressed = 0;
else
    pressed = result(3);
end
