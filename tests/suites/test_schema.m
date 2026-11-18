% TEST_SCHEMA - every device / stimulus / response / start / staircase class must describe
% its parameters consistently (this is what the documentation and protocol tools rely on)
function cases = test_schema
cases = [];
cases = rmtestCase(cases,'all classes have well-formed parameter definitions',@wellFormed);
cases = rmtestCase(cases,'class hierarchy matches the declared parent class',@parentsMatch);
cases = rmtestCase(cases,'setup and trial parameter lists can be built',@topLevel);
cases = rmtestCase(cases,'options are inherited from all ancestor classes, not only the parent',@inheritance);
cases = rmtestCase(cases,'message codes for commands are unique',@uniqueCodes);
cases = rmtestCase(cases,'protocol documentation can be generated',@documentation);
cases = rmtestCase(cases,'documentation in docs/ is up to date with the code',@documentationCurrent);

function classes = listClasses(info)
d = dir([info.root '/matlab/@*']);
classes = {};
for k=1:numel(d)
    name = d(k).name(2:end);
    if ~isempty(regexp(name,'(client|stimulus|response|start|staircase)$','once'))
        classes{end+1} = name; %#ok<AGROW>
    end
end

function params = getParams(name)
if ~isempty(regexp(name,'(client|staircase)$','once'))
    [obj,params] = feval(name,[]); %#ok<ASGLU>
else
    [obj,params] = feval(name); %#ok<ASGLU>
end

function wellFormed(info)
classes = listClasses(info);
rmtestAssert(numel(classes)>50,'Expected to find more than 50 classes, found %d',numel(classes));
problems = {};
for k=1:numel(classes)
    try
        params = getParams(classes{k});
        problems = [problems checkParams(params,classes{k})]; %#ok<AGROW>
    catch err
        problems{end+1} = sprintf('%s: %s',classes{k},err.message); %#ok<AGROW>
    end
end
rmtestAssert(isempty(problems),'%s',sprintf('\n    %s',problems{:}));

function problems = checkParams(params,where)
problems = {};
needed = {'name','type','description','required','default','classname','classdescription'};
for k=1:numel(needed)
    if ~isfield(params,needed{k})
        problems{end+1} = sprintf('%s: missing field %s',where,needed{k}); %#ok<AGROW>
        return;
    end
end
n = numel(params.name);
if n~=numel(params.type) || n~=numel(params.description) || n~=numel(params.required) || n~=numel(params.default)
    problems{end+1} = sprintf('%s: name/type/description/required/default have different lengths',where);
    return;
end
if isempty(char(params.classdescription))
    problems{end+1} = sprintf('%s: empty classdescription',where);
end
if numel(unique(params.name)) ~= n
    problems{end+1} = sprintf('%s: duplicate parameter names',where);
end
simpleTypes = {'number','boolean','string','matrix','cellarray','ignore','loadArray'};
for k=1:n
    t = params.type{k};
    here = sprintf('%s.%s',where,params.name{k});
    if ~any(params.required(k)==[0 1 2 3])
        problems{end+1} = sprintf('%s: required must be 0, 1, 2 or 3',here); %#ok<AGROW>
    end
    if ~ischar(params.description{k})
        problems{end+1} = sprintf('%s: description is not a string',here); %#ok<AGROW>
    end
    if isstruct(t)
        problems = [problems checkParams(t,here)]; %#ok<AGROW>
    elseif iscell(t)
        for m=1:numel(t)
            problems = [problems checkParams(t{m},sprintf('%s{%d}',here,m))]; %#ok<AGROW>
        end
    elseif ~ischar(t)
        problems{end+1} = sprintf('%s: type is not a string, struct or cell',here); %#ok<AGROW>
    elseif ~any(strcmp(t,simpleTypes)) && isempty(regexp(t,'^matrix_([0-9]+|n)_([0-9]+|n)$','once'))
        problems{end+1} = sprintf('%s: unknown type %s',here,t); %#ok<AGROW>
    else
        % the default value must be acceptable for the declared type
        d = params.default{k};
        tok = regexp(t,'^matrix_([0-9]+|n)_([0-9]+|n)$','tokens');
        if ~isempty(tok) && ~isempty(d) && isnumeric(d) && ~(numel(d)==1 && isnan(d))
            if ~strcmp(tok{1}{1},'n') && size(d,1)~=str2double(tok{1}{1})
                problems{end+1} = sprintf('%s: default has %d rows, type is %s',here,size(d,1),t); %#ok<AGROW>
            end
            if ~strcmp(tok{1}{2},'n') && size(d,2)~=str2double(tok{1}{2})
                problems{end+1} = sprintf('%s: default has %d columns, type is %s',here,size(d,2),t); %#ok<AGROW>
            end
        end
        if any(strcmp(t,{'number','boolean'})) && ~isempty(d) && (~isnumeric(d) && ~islogical(d) || numel(d)~=1)
            problems{end+1} = sprintf('%s: default of a %s must be a single number',here,t); %#ok<AGROW>
        end
        if strncmp(t,'matrix',6) && iscell(d)
            problems{end+1} = sprintf('%s: default of a matrix is a cell array',here); %#ok<AGROW>
        end
    end
end

function parentsMatch(info)
classes = listClasses(info);
problems = {};
for k=1:numel(classes)
    params = getParams(classes{k});
    if ~isfield(params,'parentclassname')
        continue;
    end
    src = fileread([info.root '/matlab/@' classes{k} '/' classes{k} '.m']);
    tok = regexp(src,['class\(\w+,''' classes{k} ''',(\w+)\('],'tokens','once');
    if isempty(tok)
        problems{end+1} = sprintf('%s declares the parent %s but does not inherit from any class',classes{k},params.parentclassname); %#ok<AGROW>
    elseif ~strcmp(tok{1},params.parentclassname)
        problems{end+1} = sprintf('%s declares the parent %s but inherits from %s',classes{k},params.parentclassname,tok{1}); %#ok<AGROW>
    end
end
% characterclient is a stand-alone raw socket client (known exception)
problems = problems(cellfun(@isempty,regexp(problems,'^characterclient','once')));
rmtestAssert(isempty(problems),'%s',sprintf('\n    %s',problems{:}));

function topLevel(info)
e = experiment;
[data,params] = readResources(e); %#ok<ASGLU>
problems = checkParams(params,'setup');
rmtestAssert(isempty(problems),'%s',sprintf('\n    %s',problems{:}));
rmtestAssert(any(strcmp(params.name,'keyboard')) && any(strcmp(params.name,'mouse')),'setup should list the device clients');
[data,params] = readTrialParameters(e); %#ok<ASGLU>
problems = checkParams(params,'trial');
rmtestAssert(isempty(problems),'%s',sprintf('\n    %s',problems{:}));
for f = {'stimulus','starttrial','targetType'}
    t = params.type{strcmp(params.name,f{1})};
    rmtestAssert(iscell(t) && numel(t)>3,'trial.%s should offer several classes',f{1});
end

function inheritance(info)
% forcesensors -> DAQclient -> socketclient: the options of every ancestor must be
% accepted by readParameters, listed by protocolSchema and shown in the documentation
addpath([info.root '/matlab/protocolBuilder']);
[~,params] = forcesensorsclient([]);
ancestors = getAncestorParams(params);
rmtestAssert('equal',cellfun(@(a) char(a.classname),ancestors,'UniformOutput',false),{'DAQ','socketclient'});
in = struct('gains','1','offsets','0','numchannels','2','server','localhost','port','3010');
[v,parent] = readParameters(params,in);
rmtestAssert(isfield(v,'gains') && ~isfield(v,'server') && ~isfield(v,'numchannels'),'only the options of forcesensors should stay');
rmtestAssert(isfield(parent,'numchannels') && isfield(parent,'server') && isfield(parent,'port'),'the parent and grandparent options should be passed on');
% a class whose parent gets none of its own options (only the grandparent's)
[v,parent] = readParameters(params,rmfield(in,'numchannels')); %#ok<ASGLU>
rmtestAssert(isfield(parent,'server') && ~isfield(parent,'numchannels'),'grandparent options without parent options');
% every class: the schema lists the options of all its ancestors
schema = protocolSchema;
groups = {'devices','stimulus','targetType','starttrial'};
suffix = {'client','stimulus','response','start'};
problems = {};
for g=1:numel(groups)
    names = fieldnames(schema.(groups{g}));
    for k=1:numel(names)
        cls = [names{k} suffix{g}];
        if ~exist(['@' cls],'dir') && ~exist([info.root '/matlab/@' cls],'dir')
            continue; % e.g. ATIforcesensors: the client is not called <name>client
        end
        if any(strcmp(groups{g},{'devices'}))
            [~,p] = feval(cls,[]);
        else
            [~,p] = feval(cls);
        end
        expected = {};
        a = getAncestorParams(p);
        for m=1:numel(a)
            expected = [expected a{m}.name]; %#ok<AGROW>
        end
        listed = schema.(groups{g}).(names{k});
        if isempty(listed) || ~isfield(listed,'name')
            listed = {};
        else
            listed = {listed.name};
        end
        missing = setdiff(expected,listed);
        if ~isempty(missing)
            problems{end+1} = sprintf('%s is missing inherited options: %s',cls,strjoin(missing,', ')); %#ok<AGROW>
        end
    end
end
rmtestAssert(isempty(problems),'%s',sprintf('\n    %s',problems{:}));
% and the documentation page of forcesensors shows them
[workDir,oldDir] = rmtestWorkDir();
makeProtocolDocumentation;
txt = fileread('docs/protocolDocumentation/DAQclient_forcesensors.html');
rmtestCleanup(workDir,oldDir);
for name = {'gains','numchannels','server','port','showPositionType'}
    rmtestAssert(~isempty(strfind(txt,['<code>' name{1} '</code>'])),'the forcesensors page does not show %s',name{1}); %#ok<STREMP>
end
rmtestAssert(~isempty(strfind(txt,'Options from DAQclient')) && ~isempty(strfind(txt,'(from socketclient)')),'the forcesensors page should group the inherited options'); %#ok<STREMP>

function uniqueCodes(info)
src = fileread([info.root '/matlab/messagecodes.m']);
% Only the command codes (before the "Mark event codes" section) have to be unique
commandPart = src(1:strfind(src,'%% Mark event codes')-1);
tok = regexp(commandPart,'codes\.(\w+)\s*=\s*(-?\d+);','tokens');
values = cellfun(@(c) str2double(c{2}),tok);
names = cellfun(@(c) c{1},tok,'UniformOutput',false);
[u,i] = unique(values); %#ok<ASGLU>
dup = setdiff(1:numel(values),i);
rmtestAssert(isempty(dup),'Duplicate command codes: %s',sprintf('%s ',names{dup}));
codes = messagecodes;
rmtestAssert(codes.getsample==5 && codes.markEvent==7,'messagecodes should return the codes');

function documentation(info)
[workDir,oldDir] = rmtestWorkDir();
makeProtocolDocumentation;
ok = exist('docs/protocolDocumentation/index.html','file') && ...
    exist('docs/protocolDocumentation/socketclient_mouse.html','file') && ...
    exist('docs/protocolDocumentation/stimulus_showText.html','file');
txt = '';
if ok
    txt = fileread('docs/protocolDocumentation/index.html');
end
rmtestCleanup(workDir,oldDir);
rmtestAssert(ok,'makeProtocolDocumentation did not write the expected files');
rmtestAssert(~isempty(strfind(txt,'recordingTime')) && ~isempty(strfind(txt,'monitorWidth')),'index.html is missing parameters'); %#ok<STREMP>

function documentationCurrent(info)
[workDir,oldDir] = rmtestWorkDir();
makeProtocolDocumentation;
d = dir('docs/protocolDocumentation/*.html');
stale = {};
for k=1:numel(d)
    committed = [info.root '/docs/protocolDocumentation/' d(k).name];
    if ~exist(committed,'file')
        stale{end+1} = [d(k).name ' (missing)']; %#ok<AGROW>
    elseif ~strcmp(strrep(fileread(committed),char(13),''),strrep(fileread(['docs/protocolDocumentation/' d(k).name]),char(13),''))
        stale{end+1} = d(k).name; %#ok<AGROW>
    end
end
rmtestCleanup(workDir,oldDir);
rmtestAssert(isempty(stale),'Run makeProtocolDocumentation (from the repository root) and commit docs/: out of date: %s',sprintf('%s ',stale{:}));
