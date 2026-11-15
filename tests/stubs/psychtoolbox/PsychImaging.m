% PSYCHIMAGING - stub: 'OpenWindow' is forwarded to the Screen stub, the rest is ignored
function varargout = PsychImaging(cmd,varargin)
if strcmpi(cmd,'OpenWindow')
    [varargout{1:max(nargout,1)}] = Screen('OpenWindow',varargin{:});
else
    for k=1:nargout
        varargout{k} = [];
    end
end
