% KBCHECK - stub: returns the keys that the test script says are currently pressed
function [keyIsDown,secs,keyCode] = KbCheck(varargin)
w = rmtestWorld;
w.t = w.t + w.dtCall;
rmtestWorld(w);
secs = w.t;
keyCode = zeros(1,256);
for k=1:size(w.keyScript,1)
    period = w.keyScript(k,4);
    if isinf(period)
        tt = w.t - 1000; % scripts are relative to the start of the virtual clock
    else
        tt = mod(w.t,period);
    end
    if tt >= w.keyScript(k,1) && tt < w.keyScript(k,2)
        keyCode(w.keyScript(k,3)) = 1;
    end
end
keyIsDown = any(keyCode);
