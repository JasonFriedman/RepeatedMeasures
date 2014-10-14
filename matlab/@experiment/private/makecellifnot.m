% MAKECELLIFNOT Make this field into a cell array if it is not
function data = makecellifnot(data,field)

if isempty(data.(field))
    return;
end

if ~iscell(data.(field))
    tmp = data.(field);
    data = rmfield(data,field);
    data.(field){1} = tmp;
end
