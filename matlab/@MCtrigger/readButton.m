% READBUTTON - read the value of the centre (white) button

function pressed = readButton(t)

result = getdata(t);

% (1 = not pressed, 0 = pressed in the original signal)
pressed = not(bitand(result,4));
