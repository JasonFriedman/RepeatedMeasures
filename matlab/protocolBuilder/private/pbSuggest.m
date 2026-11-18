% PBSUGGEST - " Did you mean X?" for a misspelled name (empty if nothing is close)
function text = pbSuggest(name,candidates)
text = '';
best = inf;
bestName = '';
for k=1:numel(candidates)
    d = editDistance(lower(name),lower(candidates{k}));
    if d<best
        best = d;
        bestName = candidates{k};
    end
end
if best <= max(2,floor(numel(name)/3))
    text = sprintf(' Did you mean %s?',bestName);
elseif numel(candidates)<=40
    text = sprintf(' The options are: %s.',strjoin(reshape(candidates,1,[]),', '));
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
