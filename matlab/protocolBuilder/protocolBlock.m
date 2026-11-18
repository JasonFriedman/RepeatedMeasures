% PROTOCOLBLOCK - add a block of trials made from a list of conditions
%
% p = protocolBlock(p,conditions,trialFunction,option,value,...)
%
% conditions     struct array (e.g. from protocolDesign), one element per condition
% trialFunction  function handle, options = trialFunction(condition,info), which returns
%                the options of the trial for that condition as a cell array of name,
%                value pairs (as for protocolTrial). info has the fields
%                  repetition  how many times this condition has occurred so far
%                  number      number of the trial within the block
%                  block       the name of the block
%                  filename    a unique filename made from the block name, the levels of
%                              the condition and the repetition (used if the function
%                              does not return a filename itself)
% Options:
%   'repetitions'  number of times each condition is presented (default 1)
%   'shuffle'      randomize the order (default true)
%   'name'         name of the block, used in filenames and the summary (default 'blockN')
%   'intro'        text or image number shown before the block (see protocolInstruction)
%   'breakEvery'   show a break after every N trials (default: no breaks)
%   'breakText'    text shown in the breaks (default 'Break - press space to continue')
%   'maxRepeats'   if shuffling, the largest number of times the same condition may occur
%                  in a row (default inf)
%
% e.g. conditions = protocolDesign('side',{'left','right'},'soa',[0 50 150]);
%      p = protocolBlock(p,conditions,@(c,info) {'stimulus',{'showText','text',c.side},...
%             'response','keyboard','recordingTime',3},'repetitions',4,'name','main');
function p = protocolBlock(p,conditions,trialFunction,varargin)
opts = pbToStruct(varargin,'protocolBlock');
defaults = struct('repetitions',1,'shuffle',true,'name','','intro',[],'breakEvery',inf,...
    'breakText','Break - press space to continue','maxRepeats',inf);
f = fieldnames(opts);
for k=1:numel(f)
    if ~isfield(defaults,f{k})
        error('protocolBuilder:unknown','protocolBlock has no option %s.%s',f{k},pbSuggest(f{k},fieldnames(defaults)));
    end
    defaults.(f{k}) = opts.(f{k});
end
opts = defaults;
if isempty(opts.name)
    opts.name = sprintf('block%d',numel(unique(p.blocks(~cellfun(@isempty,p.blocks))))+1);
end
order = repmat(1:numel(conditions),1,opts.repetitions);
if opts.shuffle
    order = shuffleOrder(order,opts.maxRepeats);
end
if ~isempty(opts.intro)
    p = protocolInstruction(p,opts.intro,'block',opts.name);
end
count = zeros(1,numel(conditions));
for n=1:numel(order)
    c = conditions(order(n));
    count(order(n)) = count(order(n)) + 1;
    info.repetition = count(order(n));
    info.number = n;
    info.block = opts.name;
    if isfield(c,'index')
        levels = sprintf('%d_',c.index);
    else
        levels = sprintf('%d_',order(n));
    end
    info.filename = sprintf('%s_%sr%d',opts.name,levels,info.repetition);
    args = trialFunction(c,info);
    if isstruct(args)
        args = [fieldnames(args) struct2cell(args)]';
    end
    names = args(1:2:end);
    recording = ~any(strcmp(names,'recording')) || args{2*find(strcmp(names,'recording'),1)}~=0;
    if ~any(strcmp(names,'filename')) && recording
        args = [reshape(args,1,[]) {'filename',info.filename}];
    end
    p = protocolTrial(p,args{:},'block',opts.name);
    if mod(n,opts.breakEvery)==0 && n<numel(order)
        p = protocolInstruction(p,opts.breakText,'block',opts.name);
    end
end

function order = shuffleOrder(order,maxRepeats)
for attempt=1:1000
    order = order(randperm(numel(order)));
    if isinf(maxRepeats) || longestRun(order)<=maxRepeats
        return;
    end
end
error('protocolBuilder:shuffle','Could not find an order with at most %d repeats in a row',maxRepeats);

function n = longestRun(order)
n = 1;
run = 1;
for k=2:numel(order)
    if order(k)==order(k-1)
        run = run + 1;
        n = max(n,run);
    else
        run = 1;
    end
end
