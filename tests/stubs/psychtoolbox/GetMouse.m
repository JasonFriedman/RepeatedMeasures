% GETMOUSE - stub: returns the mouse position / buttons that the test script specifies
function [x,y,buttons] = GetMouse(varargin)
w = rmtestWorld;
w.t = w.t + w.dtCall;
rmtestWorld(w);
buttons = [0 0 0];
if isempty(w.mouseScript)
    x = 0; y = 0;
    return;
end
tt = w.t - 1000;
ms = w.mouseScript;
if tt <= ms(1,1)
    row = ms(1,2:4);
elseif tt >= ms(end,1)
    row = ms(end,2:4);
else
    k = find(ms(:,1) <= tt,1,'last');
    frac = (tt - ms(k,1)) / (ms(k+1,1) - ms(k,1));
    row = ms(k,2:4) + frac * (ms(k+1,2:4) - ms(k,2:4));
    row(3) = ms(k,4);
end
x = row(1); y = row(2);
buttons(1) = row(3) > 0;
