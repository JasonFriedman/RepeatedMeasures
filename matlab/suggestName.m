% SUGGESTNAME - " Did you mean X?" for a misspelled name, or empty if nothing is close
%
% text = suggestName(name,candidates)
%
% name is compared with the candidates (a cell array of names), ignoring case. A
% candidate that differs only in case, or by at most a few letters, is suggested.
% Used in the error messages for unknown options in protocol files.

function text = suggestName(name,candidates)

text = '';
if isempty(candidates) || ~ischar(name)
    return;
end
best = inf;
bestName = '';
for k=1:numel(candidates)
    if ~ischar(candidates{k})
        continue;
    end
    d = editDistance(lower(name),lower(candidates{k}));
    if d<best
        best = d;
        bestName = candidates{k};
    end
end
if best <= max(2,floor(numel(name)/4))
    text = sprintf(' Did you mean %s?',bestName);
end

function d = editDistance(a,b)
D = zeros(numel(a)+1,numel(b)+1);
D(:,1) = 0:numel(a);
D(1,:) = 0:numel(b);
for i=1:numel(a)
    for j=1:numel(b)
        D(i+1,j+1) = min([D(i,j+1)+1, D(i+1,j)+1, D(i,j)+(a(i)~=b(j))]);
    end
end
d = D(end,end);
