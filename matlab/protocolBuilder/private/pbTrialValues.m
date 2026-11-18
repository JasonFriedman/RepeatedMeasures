% PBTRIALVALUES - check the options of a trial (or of the common section)
function values = pbTrialValues(args,where)
schema = protocolSchema;
values = pbToStruct(args,where);
% friendlier names for two of the fields
if isfield(values,'response')
    values.targetType = values.response;
    values = rmfield(values,'response');
end
if isfield(values,'start')
    values.starttrial = values.start;
    values = rmfield(values,'start');
end
kinds = {'stimulus','targetType','starttrial'};
checked = struct;
for k=1:numel(kinds)
    if isfield(values,kinds{k})
        checked.(kinds{k}) = pbClassOption(values.(kinds{k}),kinds{k},[where '.' kinds{k}],schema);
        values = rmfield(values,kinds{k});
    end
end
% lists of structs given as struct arrays become cell arrays
names = fieldnames(values);
for k=1:numel(names)
    v = values.(names{k});
    if isstruct(v) && numel(v)>1
        values.(names{k}) = num2cell(v);
    end
end
values = pbCheck(values,schema.trial,where,schema);
f = fieldnames(checked);
for k=1:numel(f)
    values.(f{k}) = checked.(f{k});
end
