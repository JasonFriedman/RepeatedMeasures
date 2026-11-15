% PSYCHPORTAUDIO - stub: records which commands were called, plays nothing
function varargout = PsychPortAudio(cmd,varargin)
w = rmtestWorld;
field = ['audio_' regexprep(cmd,'\W','')];
if ~isfield(w.calls,field)
    w.calls.(field) = 0;
end
w.calls.(field) = w.calls.(field) + 1;
switch lower(cmd)
    case {'open','createbuffer'}
        w.nextTexture = w.nextTexture + 1;
        out = {w.nextTexture};
    case 'start'
        w.audioStarted = w.audioStarted + 1;
        out = {w.t};
    case 'getaudiodata'
        out = {zeros(1,100),0,0,w.t};
    case 'getstatus'
        out = {struct('Active',0)};
    otherwise
        out = {0,0,0,0};
end
rmtestWorld(w);
for k=1:nargout
    varargout{k} = out{min(k,numel(out))};
end
