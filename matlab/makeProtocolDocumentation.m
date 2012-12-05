% MAKEPROTOCOLDOCUMENTATION - make documentation for the protocol files
% TODO - include staircase

function makeProtocolDocumentation

if ~exist('docs','dir')
    mkdir('docs');
end
if ~exist('docs/protocolDocumentation/','dir');
    mkdir('docs/protocolDocumentation/');
end

fp = fopen('docs/protocolDocumentation/index.html','w');
open_html(fp,'Protocol documentation');

fprintf(fp,'In the section experimentDescription.setup, there can be the fields below. There must be at least one of the clients.\n<BR><BR>');
[~,params] = readResources(experiment);
maketable(fp,params,[]);

fprintf(fp,'<BR><BR>Each trial can have the following fields:\n<BR><BR>');
[~,params] = readTrialParameters(experiment);
maketable(fp,params,[]);

close_html(fp);
fclose(fp);

% Make the doc for each class
function fn = makeindividualpage(params,superclassparams)
    if isfield(params,'parentclassname')
        parent = [params.parentclassname '_'];
    else
        parent = '';
    end
    fn = [parent params.classname '.html'];
    fp = fopen(['docs/protocolDocumentation/' fn],'w');
    open_html(fp,params.classname);
    fprintf(fp,'%s<BR><BR>\n',params.classdescription);
    maketable(fp,params,superclassparams)
    close_html(fp);
    fclose(fp);

function maketable(fp,params,superclassparams)

NY = 'NY';

if isempty(superclassparams) && isfield(params,'parentclassname')
    eval(['[v,superclassparams] = ' params.parentclassname ';']);
end

fprintf(fp,'<TABLE border="1">\n');
fprintf(fp,'<TR><TD>Name</TD><TD>Required</TD><TD>Type</TD><TD>Default value</TD><TD>Description</TD>\n');
    

for j=1:2
    if j==1
        p = superclassparams;
    else
        p = params;
    end
    if ~isempty(p)
        for k=1:numel(p.name)
            fprintf(fp,'<TR><TD>%s</TD>',p.name{k});
            fprintf(fp,'<TD>%s</TD>',NY(p.required(k)+1));
            if isstruct(p.type{k})
                fn = makeindividualpage(p.type{k},[]);
                fprintf(fp,'<TD><A title="follow link to see details of the struct" HREF="%s">struct</A></TD>',fn);
            elseif iscell(p.type{k})
                fprintf(fp,'<TD>One of:<BR>\n');
                for m=1:numel(p.type{k})
                    fn = makeindividualpage(p.type{k}{m},[]);
                    fprintf(fp,'<A HREF="%s">%s</A><BR>\n',fn,p.type{k}{m}.classname);
                end
                fprintf(fp,'</TD>');
            elseif strcmp(p.type{k},'number')
                fprintf(fp,'<TD><A title="A single number (i.e. not a matrix)">%s</A></TD>',p.type{k});
            elseif strcmp(p.type{k},'matrix')
                fprintf(fp,'<TD><A title="A matrix (see description for how to fill it)">%s</A></TD>',p.type{k});
            elseif strncmp(p.type{k},'matrix_',7)
                r = regexp(p.type{k},'matrix_([n0-9]*)_([n0-9]*)','tokens');
                for b=1:2
                    if strcmp(r{1}{b},'n')
                        num(b) = 'n';
                    else
                        num(b) = num2str(r{1}{b});
                    end
                end
                fprintf(fp,'<TD><A title="A %c by %c matrix (see description for how to fill it)">%c by %c matrix</A></TD>',num(1),num(2),num(1),num(2));
            elseif strcmp(p.type{k},'ignore')
                fprintf(fp,'<TD></TD>');
            else
                fprintf(fp,'<TD>%s</TD>',p.type{k});
            end
            if isempty(p.default{k})
                fprintf(fp,'<TD>[]</TD>');
            elseif isnumeric(p.default{k}) && numel(p.default{k})>1
                fprintf(fp,'<TD>[');
                for n=1:numel(p.default{k})
                    if round(p.default{k}(n))==p.default{k}(n)
                        fprintf(fp,'%d',p.default{k}(n));
                    else
                        fprintf(fp,'%.2f',p.default{k}(n));
                    end
                    if n<numel(p.default{k})
                        fprintf(fp,',');
                    end
                end
                fprintf(fp,']</TD>');
            else
                if isstruct(p.default{k})
                    f = fields(p.default{k});
                    fprintf(fp,'<TD>');
                    for m=1:numel(f)
                        fprintf(fp,'%s: ',f{m});
                        if round(p.default{k}.(f{m}))==p.default{k}.(f{m})
                            fprintf(fp,'%d</BR>',p.default{k}.(f{m}));
                        else
                            printf(fp,'%.2f</BR>',p.default{k}.(f{m}));
                        end
                    end
                    fprintf(fp,'</TD>');
                elseif round(p.default{k})==p.default{k}
                    fprintf(fp,'<TD>%d</TD>',p.default{k});
                else
                    fprintf(fp,'<TD>%.2f</TD>',p.default{k});
                end
            end
            fprintf(fp,'<TD>%s</TD></TR>\n',p.description{k});
        end
    end
end
fprintf(fp,'</TABLE>');

function open_html(fp,name)
fprintf(fp,'<HTML>\n<HEAD><TITLE>%s</TITLE></HEAD>\n<BODY><H1>%s</H1>\n',name,name);

function close_html(fp)

fprintf(fp,'</BODY></HTML>');

function checkparams(params)
    if ~isfield(params,'name')
        error([thisname ': params must contain a field name with a cell array of names of the parameters']);
    end
    if ~isfield(params,'type')
        error([thisname ': params must contain a field type with a cell array of the types of the parameters (number, string, etc)']);
    end
    if ~isfield(params,'description')
        error([thisname ': params must contain a field description with a cell array with descriptions of the parameters']);
    end
    if ~isfield(params,'default')
        error([thisname ': params must contain a field default with a cell array with the default value of the parameters']);
    end
    if ~isfield(params,'required')
        error([thisname ': params must contain a field required with a matrix with whether this parameter is required (1) or optional (0)']);
    end
    if ~isfield(params,'classdescription')
        error([thisname ': params must contain a field classdescription that describes the class']);
    end
    
    if (numel(params.name) ~= numel(params.type) || ...
        numel(params.name) ~= numel(params.description) || ...
        numel(params.name) ~= numel(params.required) || ...
        numel(params.name) ~= numel(params.default))
        error('The number of elements must be the same in all fields of params');
    end
