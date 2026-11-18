% SCREEN - stub of the Psychtoolbox Screen function for running tests without a display
%
% Nothing is drawn. Every sub-command is counted in rmtestWorld().calls, text that is
% drawn is stored in rmtestWorld().texts, and Screen('Flip') advances the virtual clock
% by one frame.
function varargout = Screen(varargin)
w = rmtestWorld;
% Both Screen('Command',window,...) and the old Screen(window,'Command',...) are allowed
if ischar(varargin{1})
    cmd = varargin{1};
    args = varargin(2:end);
else
    cmd = varargin{2};
    args = [varargin(1) varargin(3:end)];
end
field = regexprep(cmd,'\W','');
if ~isfield(w.calls,field)
    w.calls.(field) = 0;
end
w.calls.(field) = w.calls.(field) + 1;
out = {};
switch lower(cmd)
    case 'screens'
        out = {0};
    case 'openwindow'
        out = {1,w.screenRect};
    case 'rect'
        out = {w.screenRect};
    case 'windowsize'
        out = {w.screenRect(3),w.screenRect(4)};
    case 'getflipinterval'
        out = {w.flipInterval};
    case {'framerate','nominalframerate'}
        out = {1/w.flipInterval};
    case 'flip'
        % If a time was requested, wait until then (at least one frame)
        w.t = w.t + w.flipInterval;
        if numel(args)>=2 && ~isempty(args{2}) && args{2} > w.t
            w.t = args{2};
        end
        out = {w.t,w.t,w.t,0,0};
    case 'textbounds'
        n = numel(args{2});
        out = {[0 0 max(10*n,1) 20],[0 0 max(10*n,1) 20]};
    case 'drawtext'
        w.texts{end+1} = args{2};
        out = {0,0,0};
    case {'maketexture','openoffscreenwindow'}
        w.nextTexture = w.nextTexture + 1;
        out = {w.nextTexture};
    case 'getimage'
        % Always "white": tests of color-based responses can change this field
        if isfield(w,'pixelColor')
            c = w.pixelColor;
        else
            c = [255 255 255];
        end
        out = {reshape(uint8(c),[1 1 3])};
    case 'preference'
        out = {0};
    case 'textsize'
        out = {12};
    case 'textfont'
        out = {'Courier',0};
    case 'textstyle'
        out = {0};
    case 'openmovie'
        out = {-1,0,0,0,0,0};
    case 'getmovieimage'
        out = {-1,0};
    case 'playmovie'
        out = {0};
    otherwise
        % Drawing commands etc.: nothing to return
        out = {0,0,0,0,0};
end
rmtestWorld(w);
for k=1:nargout
    varargout{k} = out{min(k,numel(out))};
end
