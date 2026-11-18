% RMTESTWORLD - access the simulated "world" used by the Psychtoolbox / device stubs
%
% w = rmtestWorld          - get the world struct
% rmtestWorld(w)           - replace the world struct
% rmtestWorld('reset')     - reset to defaults
%
% The world holds a virtual clock (so tests run much faster than real time and are
% deterministic), scripted keyboard / mouse input and counters of what was drawn.
%
% Fields:
%   t            virtual time in seconds
%   dtCall       how much the clock advances on every GetSecs / KbCheck / GetMouse call
%   flipInterval how much the clock advances on every Screen('Flip')
%   keyScript    N x 4 matrix: [tDown tUp keyCode period]. The key is down when
%                tDown <= mod(t,period) < tUp (use period = inf for a single press)
%   mouseScript  N x 4 matrix: [t x y button], linearly interpolated in time (x,y in pixels)
%   screenRect   size of the simulated screen
%   calls        struct with a count of every Screen sub-command called
%   texts        cell array of every string drawn with DrawText / DrawFormattedText
function out = rmtestWorld(in)
persistent w
if isempty(w) || (nargin==1 && ischar(in) && strcmp(in,'reset'))
    w = struct('t',1000,'dtCall',1e-4,'flipInterval',1/60,'keyScript',zeros(0,4),...
        'mouseScript',zeros(0,4),'screenRect',[0 0 1280 720],'calls',struct(),...
        'texts',{{}},'nextTexture',10,'servers',{{}},'sockets',{{}},'audioStarted',0);
end
if nargin==1 && isstruct(in)
    w = in;
end
out = w;
