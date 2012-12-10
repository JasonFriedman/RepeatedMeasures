% GETBUTTONS - get the latest state of the buttons
% [buttons] = getbuttons(t)
%
% It should produce a 1xN array of data

function buttons = getbuttons(t)

pkt = WinTabMex(5);

if isempty(pkt)
    buttons = [];
else
    buttons = uint32(pkt(4));
end
