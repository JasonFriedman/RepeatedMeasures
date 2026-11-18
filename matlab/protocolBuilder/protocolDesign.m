% PROTOCOLDESIGN - make the list of conditions of a (full factorial) design
%
% conditions = protocolDesign(factor1,levels1,factor2,levels2,...)
%
% e.g. conditions = protocolDesign('side',{'left','right'},'congruent',[1 0],'soa',[0 50 150]);
%
% returns a struct array with one element per combination (here 2 x 2 x 3 = 12), with the
% fields side, congruent and soa. Each element also has the field index (the number of
% the level of each factor, e.g. [1 2 3]), which is handy for making filenames.
% Use protocolBlock to turn conditions into (repeated, shuffled) trials.
function conditions = protocolDesign(varargin)
if mod(nargin,2)~=0 || nargin==0
    error('protocolBuilder:pairs','protocolDesign needs pairs of a factor name and its levels');
end
names = varargin(1:2:end);
levels = varargin(2:2:end);
counts = zeros(1,numel(levels));
for k=1:numel(levels)
    if ischar(levels{k})
        levels{k} = {levels{k}};
    end
    counts(k) = numel(levels{k});
end
total = prod(counts);
conditions = struct('index',cell(1,total));
for n=1:total
    % the first factor changes slowest
    rest = n-1;
    idx = zeros(1,numel(counts));
    for k=numel(counts):-1:1
        idx(k) = mod(rest,counts(k)) + 1;
        rest = floor(rest/counts(k));
    end
    for k=1:numel(names)
        if iscell(levels{k})
            conditions(n).(names{k}) = levels{k}{idx(k)};
        else
            conditions(n).(names{k}) = levels{k}(idx(k));
        end
    end
    conditions(n).index = idx;
end
