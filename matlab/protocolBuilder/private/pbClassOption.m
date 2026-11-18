% PBCLASSOPTION - check a stimulus / targetType / starttrial value
%
% v = pbClassOption(v,kind,where,schema)
%
% v can be a name ('keyboard'), a name with options ({'showText','text','Hello'}) or a
% struct (struct('showText',struct('text','Hello'))). Returns the form used in protocols.
function v = pbClassOption(v,kind,where,schema)
options = schema.(kind);
if iscell(v)
    name = v{1};
    opts = pbToStruct(v(2:end),[where '.' name]);
elseif ischar(v)
    name = v;
    opts = struct;
elseif isstruct(v)
    f = fieldnames(v);
    name = f{1};
    opts = v.(name);
else
    error('protocolBuilder:type','%s should be a name, {name, option, value, ...} or a struct',where);
end
if ~isfield(options,name)
    error('protocolBuilder:unknown','%s: there is no %s called %s.%s',where,kind,name,pbSuggest(name,fieldnames(options)));
end
params = options.(name);
opts = pbCheck(opts,params,[where '.' name],schema);
missing = {};
for k=1:numel(params)
    if any(params(k).required==[1 3]) && ~isfield(opts,params(k).name)
        missing{end+1} = params(k).name; %#ok<AGROW>
    end
end
if ~isempty(missing)
    error('protocolBuilder:missing','%s.%s needs: %s',where,name,strjoin(missing,', '));
end
if isempty(fieldnames(opts))
    v = name;
else
    v = struct(name,opts);
end
