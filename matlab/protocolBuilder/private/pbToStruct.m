% PBTOSTRUCT - turn {'name',value,...} into a struct (structs are returned unchanged)
function s = pbToStruct(v,where)
if isstruct(v)
    s = v;
elseif isempty(v)
    s = struct;
elseif iscell(v)
    if mod(numel(v),2)~=0
        error('protocolBuilder:pairs','%s: options must be given as name, value pairs',where);
    end
    s = struct;
    for k=1:2:numel(v)
        if ~ischar(v{k})
            error('protocolBuilder:pairs','%s: option names must be text',where);
        end
        s.(v{k}) = v{k+1};
    end
else
    error('protocolBuilder:pairs','%s: expected a struct or name, value pairs',where);
end
