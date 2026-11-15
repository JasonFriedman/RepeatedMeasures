% SOUND - stub: counts the calls, plays nothing
function sound(varargin)
w = rmtestWorld;
if ~isfield(w.calls,'sound')
    w.calls.sound = 0;
end
w.calls.sound = w.calls.sound + 1;
rmtestWorld(w);
