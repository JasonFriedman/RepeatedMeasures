% PROTOCOLSETUP - set options in the setup section of a protocol
%
% p = protocolSetup(p,name,value,...)
%
% e.g. p = protocolSetup(p,'images',{'a.png','b.png'},'targetPosition',[0.5 0.2;0.5 0.8]);
%
% Lists of structs can be written compactly as a cell array with one row of values per
% item, in the order of the fields: 'beeps',{[1000 0.1],[500 0.2]} is the same as
% beeps{1}.frequency = 1000; beeps{1}.duration = 0.1; beeps{2}.frequency = 500; ...
% and 'labels',{{[0.5 0.1],20,'Left'}} is location, fontSize, text.
%
% See protocolOptions('setup') for the list of options.
function p = protocolSetup(p,varargin)
schema = protocolSchema;
values = pbToStruct(varargin,'setup');
names = fieldnames(values);
for k=1:numel(names)
    idx = find(strcmp({schema.setup.name},names{k}));
    if isfield(schema.devices,names{k})
        error('protocolBuilder:device','%s is a device: use protocolDevice(p,''%s'',...)',names{k},names{k});
    end
    if ~isempty(idx) && strcmp(schema.setup(idx).type,'struct')
        values.(names{k}) = expandRows(values.(names{k}),schema.setup(idx).children);
    end
end
values = pbCheck(values,schema.setup,'setup',schema);
for k=1:numel(names)
    p.description.setup.(names{k}) = values.(names{k});
end

function v = expandRows(v,children)
% {[1000 0.1],[500 0.2]} or {{[0.5 0.1],20,'Left'}} -> cell array of structs
if ~iscell(v) || isempty(v) || isstruct(v{1}) || ischar(v{1})
    return;
end
fieldNames = {children.name};
out = cell(1,numel(v));
for k=1:numel(v)
    row = v{k};
    if isnumeric(row)
        row = num2cell(row);
    end
    if numel(row)>numel(fieldNames)
        error('protocolBuilder:type','Too many values (%d) for a struct with the fields %s',numel(row),strjoin(fieldNames,', '));
    end
    out{k} = cell2struct(reshape(row,[],1),reshape(fieldNames(1:numel(row)),[],1),1);
end
v = out;
