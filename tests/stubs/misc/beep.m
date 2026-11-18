% BEEP - stub: counts the calls, plays nothing
function beep(varargin)
w = rmtestWorld;
if ~isfield(w.calls,'beep')
    w.calls.beep = 0;
end
w.calls.beep = w.calls.beep + 1;
rmtestWorld(w);
