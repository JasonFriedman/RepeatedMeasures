% GETSECS - stub: returns the virtual time, which advances a little on every call
function t = GetSecs
w = rmtestWorld;
w.t = w.t + w.dtCall;
rmtestWorld(w);
t = w.t;
