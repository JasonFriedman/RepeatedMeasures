% PROTOCOLTRIAL - add a trial to a protocol
%
% p = protocolTrial(p,name,value,...)
%
% e.g. p = protocolTrial(p,'stimulus',{'showText','text','Go'},...
%                          'response',{'targetInSpace','targets',[2 3],'threshold',3},...
%                          'start',{'targetInSpace','target',1,'threshold',3},...
%                          'targetNum',2,'recordingTime',5,'filename','left_1',...
%                          'beep',struct('time',{0.5 1},'beepNumber',{1 1}));
%
% stimulus, response (= targetType) and start (= starttrial) are either a name
% ('keyboard', 'dontWait', 'fixation') or a cell array with the name followed by its
% options. Lists (beep, trigger, playAudioFile, ...) can be struct arrays.
%
% Names and values are checked immediately (with a suggestion for misspelled names), so
% mistakes are reported at the line where they are made. If no stimulus is given, 'none'
% is used. See protocolOptions('trial'), protocolOptions('stimulus'), ...
function p = protocolTrial(p,varargin)
n = numel(p.description.trial) + 1;
where = sprintf('trial %d',n);
% an optional block name: protocolTrial(p,...,'block','practice')
args = varargin;
block = '';
idx = find(strcmp(args(1:2:end),'block'));
if ~isempty(idx)
    block = args{2*idx(1)};
    args(2*idx(1)-1:2*idx(1)) = [];
end
values = pbTrialValues(args,where);
if ~isfield(values,'stimulus')
    values.stimulus = 'none';
end
% options from the common section count as well
merged = values;
if isfield(p.description,'common')
    f = fieldnames(p.description.common);
    for k=1:numel(f)
        merged.(f{k}) = p.description.common.(f{k});
    end
end
if ~isfield(merged,'recordingTime')
    error('protocolBuilder:missing','%s: recordingTime must be specified (0 = until the start condition is met again, inf = until the response)',where);
end
recording = ~isfield(merged,'recording') || merged.recording~=0;
if recording && merged.recordingTime>0 && ~isfield(values,'filename') && ~any(strcmp(pbName(values.stimulus),{'showImage'}))
    error('protocolBuilder:missing','%s: a filename is needed when recording (or set ''recording'',0)',where);
end
if isfield(values,'filename')
    for k=1:n-1
        if isfield(p.description.trial{k},'filename') && strcmp(p.description.trial{k}.filename,values.filename)
            error('protocolBuilder:filename','%s: the filename %s is already used by trial %d (the data would be overwritten)',where,values.filename,k);
        end
    end
end
p.description.trial{n} = values;
p.blocks{n} = block;

function name = pbName(v)
if ischar(v)
    name = v;
else
    f = fieldnames(v);
    name = f{1};
end
