% PROTOCOLSCHEMA - all the options that can be used in a protocol, extracted from the code
%
% schema = protocolSchema
%
% The schema is built from the parameter definitions inside the classes (the same
% information that makeProtocolDocumentation uses), so it is always in step with the code.
%
% schema.setup      parameters of the setup section (struct array, see below)
% schema.trial      parameters of a trial (and of the common section)
% schema.devices    struct, one field per recording device (client), each a struct array
% schema.stimulus   struct, one field per stimulus
% schema.targetType struct, one field per response
% schema.starttrial struct, one field per way of starting a trial
% schema.staircases struct, one field per staircase
% schema.descriptions   struct with the description of every device / stimulus / ...
%
% Each parameter is a struct with the fields
%   name, type, required (0 = no, 1 = yes, 2 = zero or more, 3 = one or more), default,
%   description and children. type is 'number', 'boolean', 'string', 'matrix',
%   'matrix_R_C', 'cellarray', 'struct' (children = its parameters) or 'oneof'
%   (children = struct with one field per option).
function schema = protocolSchema
persistent cached
if ~isempty(cached)
    schema = cached;
    return;
end
e = experiment;
[data,setupParams] = readResources(e); %#ok<ASGLU>
[data,trialParams] = readTrialParameters(e); %#ok<ASGLU>

schema.descriptions = struct;
schema.devices = struct;
clients = get(e,'allclients');
isDevice = false(1,numel(setupParams.name));
for k=1:numel(setupParams.name)
    if any(strcmp(setupParams.name{k},clients)) && isstruct(setupParams.type{k})
        isDevice(k) = true;
        p = setupParams.type{k};
        schema.devices.(setupParams.name{k}) = [convert(parentParams(p)) convert(p)];
        schema.descriptions.devices.(setupParams.name{k}) = char(p.classdescription);
    end
end
schema.setup = convert(subset(setupParams,~isDevice));
schema.trial = convert(trialParams);

kinds = {'stimulus','targetType','starttrial'};
for k=1:numel(kinds)
    options = trialParams.type{strcmp(trialParams.name,kinds{k})};
    schema.(kinds{k}) = struct;
    for m=1:numel(options)
        schema.(kinds{k}).(options{m}.classname) = convert(options{m});
        schema.descriptions.(kinds{k}).(options{m}.classname) = char(options{m}.classdescription);
    end
end
schema.staircases = struct;
options = setupParams.type{strcmp(setupParams.name,'staircases')};
for m=1:numel(options)
    schema.staircases.(options{m}.classname) = convert(options{m});
    schema.descriptions.staircases.(options{m}.classname) = char(options{m}.classdescription);
end
cached = schema;

function p = parentParams(params)
p = struct('name',{{}},'type',{{}},'description',{{}},'required',[],'default',{{}});
if isfield(params,'parentclassname')
    [obj,p] = feval(params.parentclassname); %#ok<ASGLU>
end

function params = subset(params,keep)
params.name = params.name(keep);
params.type = params.type(keep);
params.description = params.description(keep);
params.required = params.required(keep);
params.default = params.default(keep);

function out = convert(params)
out = struct('name',{},'type',{},'required',{},'default',{},'description',{},'children',{});
for k=1:numel(params.name)
    t = params.type{k};
    item.name = params.name{k};
    item.required = params.required(k);
    item.default = params.default{k};
    item.description = params.description{k};
    item.children = [];
    if isstruct(t)
        item.type = 'struct';
        item.children = convert(t);
        if isstruct(item.default) || isobject(item.default)
            item.default = [];
        end
    elseif iscell(t)
        item.type = 'oneof';
        item.children = struct;
        for m=1:numel(t)
            item.children.(t{m}.classname) = convert(t{m});
        end
    else
        item.type = t;
    end
    out(end+1) = item; %#ok<AGROW>
end
