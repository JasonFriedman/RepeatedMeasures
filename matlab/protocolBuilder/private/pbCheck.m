% PBCHECK - check a struct of values against a list of parameters, and tidy the values
%
% s = pbCheck(s,params,where,schema)
%
% Errors (with a suggestion) for unknown names and for values of the wrong type or size.
% Logical values are converted to 0 / 1, and "class with options" values written as
% {'name','option',value,...} are expanded.
function s = pbCheck(s,params,where,schema)
names = fieldnames(s);
for k=1:numel(names)
    idx = find(strcmp({params.name},names{k}));
    if isempty(idx)
        error('protocolBuilder:unknown','%s has no option called %s.%s',where,names{k},pbSuggest(names{k},{params.name}));
    end
    p = params(idx);
    v = s.(names{k});
    here = [where '.' names{k}];
    if islogical(v)
        v = double(v);
    end
    switch p.type
        case {'number','boolean'}
            if ~(isnumeric(v) && numel(v)==1)
                error('protocolBuilder:type','%s should be a single number, not %s',here,pbValueToText(v));
            end
            if strcmp(p.type,'boolean') && ~any(v==[0 1])
                error('protocolBuilder:type','%s should be 0 or 1 (or true / false)',here);
            end
        case 'string'
            if isnumeric(v) && numel(v)==1
                v = num2str(v);
            elseif ~ischar(v)
                error('protocolBuilder:type','%s should be text, not %s',here,pbValueToText(v));
            end
        case 'cellarray'
            if ~(iscell(v) || ischar(v) || isnumeric(v))
                error('protocolBuilder:type','%s should be a cell array',here);
            end
        case 'struct'
            v = checkStructs(v,p.children,here,schema);
        case 'oneof'
            v = checkOneOf(v,p,here,schema);
        case 'ignore'
            % stimulus / targetType / starttrial / devices are handled by the caller
        otherwise
            tok = regexp(p.type,'^matrix(?:_([0-9]+|n)_([0-9]+|n))?$','tokens','once');
            if ~isempty(tok) || strcmp(p.type,'matrix')
                if ~isnumeric(v)
                    error('protocolBuilder:type','%s should be a matrix of numbers, not %s',here,pbValueToText(v));
                end
                if numel(tok)==2 && ~isempty(tok{1})
                    if ~strcmp(tok{1},'n') && size(v,1)~=str2double(tok{1})
                        error('protocolBuilder:type','%s should have %s row(s), it has %d',here,tok{1},size(v,1));
                    end
                    if ~strcmp(tok{2},'n') && size(v,2)~=str2double(tok{2})
                        error('protocolBuilder:type','%s should have %s column(s), it has %d',here,tok{2},size(v,2));
                    end
                end
            end
    end
    s.(names{k}) = v;
end

function v = checkStructs(v,children,here,schema)
% one struct, a struct array or a cell array of structs (a list)
if isstruct(v) && numel(v)>1
    v = num2cell(v);
end
if iscell(v)
    for m=1:numel(v)
        v{m} = pbCheck(pbToStruct(v{m},here),children,sprintf('%s{%d}',here,m),schema);
    end
else
    v = pbCheck(pbToStruct(v,here),children,here,schema);
end

function v = checkOneOf(v,p,here,schema)
if iscell(v) && ~isempty(v) && ischar(v{1}) && isfield(p.children,v{1})
    v = {v}; % a single {'name',...}
end
if isstruct(v)
    v = {v};
end
if ~iscell(v)
    error('protocolBuilder:type','%s should be one of: %s',here,strjoin(fieldnames(p.children)',', '));
end
for m=1:numel(v)
    item = v{m};
    if iscell(item)
        item = struct(item{1},pbToStruct(item(2:end),here));
    end
    f = fieldnames(item);
    if ~isfield(p.children,f{1})
        error('protocolBuilder:unknown','%s: unknown option %s.%s',here,f{1},pbSuggest(f{1},fieldnames(p.children)));
    end
    item.(f{1}) = pbCheck(item.(f{1}),p.children.(f{1}),[here '.' f{1}],schema);
    v{m} = item;
end
