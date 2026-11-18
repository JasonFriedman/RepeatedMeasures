% PROTOCOLINSTRUCTION - add a trial that shows instructions (text or an image)
%
% p = protocolInstruction(p,text)          show text until the start condition (default:
%                                          a key press)
% p = protocolInstruction(p,imageNumber)   show an image from setup.images
% p = protocolInstruction(p,...,name,value,...)   any other trial options, e.g.
%                                          'start','dontWait','recordingTime',10
%
% Nothing is recorded in these trials.
function p = protocolInstruction(p,content,varargin)
opts = pbToStruct(varargin,'instruction');
if isfield(opts,'starttrial')
    opts.start = opts.starttrial;
    opts = rmfield(opts,'starttrial');
end
if ~isfield(opts,'start') && ~(isfield(p.description,'common') && isfield(p.description.common,'starttrial'))
    opts.start = 'keyboard';
end
if ~isfield(opts,'recordingTime')
    opts.recordingTime = 0;
end
opts.recording = 0;
if ischar(content)
    opts.stimulus = {'showText','text',content};
elseif isnumeric(content) && numel(content)==1
    if ~isfield(p.description.setup,'images') || numel(p.description.setup.images)<content
        error('protocolBuilder:missing','Image %d is not defined: add the images first with protocolSetup(p,''images'',{...})',content);
    end
    opts.stimulus = {'showImage','stimuli',content};
else
    error('protocolBuilder:type','The instruction should be text or the number of an image');
end
args = [fieldnames(opts) struct2cell(opts)]';
p = protocolTrial(p,args{:});
