% PBVALUETOTEXT - short text version of a value (for messages)
function s = pbValueToText(v)
if ischar(v)
    s = ['''' v ''''];
elseif isnumeric(v) || islogical(v)
    s = mat2str(double(v),5);
elseif iscell(v)
    parts = cell(1,numel(v));
    for k=1:numel(v)
        parts{k} = pbValueToText(v{k});
    end
    s = ['{' strjoin(parts,', ') '}'];
elseif isstruct(v)
    s = '(struct)';
else
    s = ['(' class(v) ')'];
end
if numel(s)>60
    s = [s(1:57) '...'];
end
