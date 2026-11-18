% PROTOCOLSCHEMAEXPORT - write all the protocol options to a JSON file
%
% protocolSchemaExport(filename)
%
% The JSON file contains the same information as protocolSchema (every setup and trial
% option, device, stimulus, response and start with their types, defaults and
% descriptions). It is meant for tools written in other languages: editors, validators,
% and the port of RepeatedMeasures (see docs/porting).
function protocolSchemaExport(filename)
schema = protocolSchema;
fp = fopen(filename,'w');
if fp==-1
    error('Cannot open %s for writing',filename);
end
fprintf(fp,'%s\n',toJSON(schema,0));
fclose(fp);

function s = toJSON(v,level)
pad = repmat(' ',1,2*(level+1));
padEnd = repmat(' ',1,2*level);
if isstruct(v)
    if numel(v)~=1 || (isfield(v,'name') && isfield(v,'children'))
        % a list of parameters
        parts = cell(1,numel(v));
        for k=1:numel(v)
            parts{k} = [pad objectJSON(v(k),level+1)];
        end
        if isempty(parts)
            s = '[]';
        else
            s = sprintf('[\n%s\n%s]',strjoin(parts,sprintf(',\n')),padEnd);
        end
    else
        s = objectJSON(v,level);
    end
elseif ischar(v)
    s = ['"' escape(v) '"'];
elseif iscell(v)
    parts = cell(1,numel(v));
    for k=1:numel(v)
        parts{k} = toJSON(v{k},level+1);
    end
    s = ['[' strjoin(parts,', ') ']'];
elseif isnumeric(v) || islogical(v)
    s = numberJSON(double(v));
else
    s = 'null';
end

function s = objectJSON(v,level)
pad = repmat(' ',1,2*(level+1));
padEnd = repmat(' ',1,2*level);
f = fieldnames(v);
parts = cell(1,numel(f));
for k=1:numel(f)
    parts{k} = sprintf('%s"%s": %s',pad,f{k},toJSON(v.(f{k}),level+1));
end
if isempty(parts)
    s = '{}';
else
    s = sprintf('{\n%s\n%s}',strjoin(parts,sprintf(',\n')),padEnd);
end

function s = numberJSON(v)
if isempty(v)
    s = 'null';
elseif numel(v)==1
    if isnan(v)
        s = '"NaN"';
    elseif isinf(v)
        if v>0, s = '"Inf"'; else, s = '"-Inf"'; end
    else
        s = sprintf('%.10g',v);
    end
elseif size(v,1)==1 || size(v,2)==1
    parts = cell(1,numel(v));
    for k=1:numel(v)
        parts{k} = numberJSON(v(k));
    end
    s = ['[' strjoin(parts,', ') ']'];
else
    parts = cell(1,size(v,1));
    for k=1:size(v,1)
        parts{k} = numberJSON(v(k,:));
    end
    s = ['[' strjoin(parts,', ') ']'];
end

function s = escape(s)
s = strrep(s,'\','\\');
s = strrep(s,'"','\"');
s = strrep(s,sprintf('\n'),'\n');
s = strrep(s,sprintf('\r'),'');
s = strrep(s,sprintf('\t'),' ');
