% WAITSECS - stub: advances the virtual clock without really waiting
function t = WaitSecs(varargin)
w = rmtestWorld;
if nargin>=1 && isnumeric(varargin{1})
    w.t = w.t + varargin{1};
elseif nargin>=2 && isnumeric(varargin{2})
    w.t = w.t + varargin{2};
end
rmtestWorld(w);
t = w.t;
