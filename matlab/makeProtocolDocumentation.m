% MAKEPROTOCOLDOCUMENTATION - make documentation for the protocol files
%
% makeProtocolDocumentation
%
% Writes the HTML documentation of all the options that can be used in a protocol file to
% docs/protocolDocumentation (relative to the current directory), with one page for the
% setup and trial sections (index.html) and one page for each device, stimulus, response,
% start and struct. The information comes from the parameter definitions in the classes.
% Run it from the root of the repository after changing any parameters.

function makeProtocolDocumentation

outDir = 'docs/protocolDocumentation';
if ~exist(outDir,'dir')
    mkdir(outDir);
end
writeStylesheet([outDir '/style.css']);

[~,setupParams] = readResources(experiment);
[~,trialParams] = readTrialParameters(experiment);

fp = fopen([outDir '/index.html'],'w');
openPage(fp,'Protocol reference','',[]);

fprintf(fp,'<p class="lead">All the options that can be used in a protocol file. ');
fprintf(fp,'This page is generated from the code by <code>makeProtocolDocumentation</code>, so it matches the version of Repeated Measures in this repository.</p>\n');

fprintf(fp,'<nav class="toc" aria-label="Contents"><ul>\n');
fprintf(fp,'<li><a href="#structure">Structure of a protocol</a></li>\n');
fprintf(fp,'<li><a href="#devices">Recording devices</a></li>\n');
fprintf(fp,'<li><a href="#stimuli">Stimuli</a></li>\n');
fprintf(fp,'<li><a href="#responses">Responses</a></li>\n');
fprintf(fp,'<li><a href="#starts">Trial starts</a></li>\n');
fprintf(fp,'<li><a href="#setup">Setup options</a></li>\n');
fprintf(fp,'<li><a href="#trial">Trial options</a></li>\n');
fprintf(fp,'</ul></nav>\n');

fprintf(fp,'<h2 id="structure">Structure of a protocol</h2>\n');
fprintf(fp,'<p>A protocol has a <code>setup</code> section, which lists the recording devices and the resources used in the experiment (images, sounds, beeps, targets, ...), ');
fprintf(fp,'a list of trials, and optionally a <code>common</code> section with trial options that are the same in every trial. ');
fprintf(fp,'In a <code>generateProtocol.m</code> file this looks like:</p>\n');
fprintf(fp,'<pre><code>');
exampleLines = {
    'experimentDescription.setup.tablet.maxx = 48767;        % a recording device'
    'experimentDescription.setup.tablet.maxy = 30479;'
    'experimentDescription.setup.images = {''target.png''};    % setup options'
    'experimentDescription.common.starttrial = ''keyboard'';   % the same in every trial'
    ''
    'experimentDescription.trial{1}.stimulus.showImage.stimuli = 1;'
    'experimentDescription.trial{1}.targetType = ''keyboard'';'
    'experimentDescription.trial{1}.recordingTime = 5;'
    'experimentDescription.trial{1}.filename = ''trial1'';'
    ''
    'tree = struct2xml(experimentDescription);'
    'save(tree,''protocols/subject1.xml'');'};
fprintf(fp,'%s\n',esc(strjoin(exampleLines',sprintf('\n'))));
fprintf(fp,'</code></pre>\n');
fprintf(fp,'<p>The <a href="https://github.com/JasonFriedman/RepeatedMeasures/tree/master/matlab/protocolBuilder">protocol builder</a> ');
fprintf(fp,'writes these files for you and checks the options as they are set. In MATLAB, <code>protocolOptions(''name'')</code> shows the same information as these pages.</p>\n');

% Lists of the classes (the pages themselves are written while making the tables below)
devices = {};
deviceNames = {};
for k=1:numel(setupParams.name)
    t = setupParams.type{k};
    if isstruct(t) && isfield(t,'parentclassname') && ~isempty(regexp(t.parentclassname,'client$','once'))
        devices{end+1} = t; %#ok<AGROW>
        deviceNames{end+1} = ['setup-' setupParams.name{k}]; %#ok<AGROW>
    end
end
fprintf(fp,'<h2 id="devices">Recording devices</h2>\n');
fprintf(fp,'<p>Add a device to the setup section under its name, e.g. <code>setup.tablet</code>. At least one device is needed.</p>\n');
classList(fp,devices,deviceNames);
lists = {'stimulus','stimuli','Stimuli','Set with <code>trial{n}.stimulus</code>.'
    'targetType','responses','Responses','Set with <code>trial{n}.targetType</code>. The default is <code>dummy</code> (no response).'
    'starttrial','starts','Trial starts','Set with <code>trial{n}.starttrial</code>. The default is <code>dontWait</code>.'};
for k=1:size(lists,1)
    fprintf(fp,'<h2 id="%s">%s</h2>\n<p>%s</p>\n',lists{k,2},lists{k,3},lists{k,4});
    classList(fp,trialParams.type{strcmp(trialParams.name,lists{k,1})},{});
end

fprintf(fp,'<h2 id="setup">Setup options</h2>\n');
fprintf(fp,'<p>Options in <code>experimentDescription.setup</code>.</p>\n');
fprintf(fp,'<p>The recording devices (<a href="#devices">listed above</a>) are also options in the setup section.</p>\n');
makeTable(fp,setupParams,struct('file','index.html','title','Setup options','prefix','setup-','summarize',1));

fprintf(fp,'<h2 id="trial">Trial options</h2>\n');
fprintf(fp,'<p>Options in each <code>experimentDescription.trial{n}</code> (or in <code>experimentDescription.common</code>).</p>\n');
makeTable(fp,trialParams,struct('file','index.html','title','Trial options','prefix','trial-','summarize',1));

closePage(fp);
fclose(fp);

% A table of classes with their descriptions (for the index page)
function classList(fp,classes,ids)
fprintf(fp,'<div class="table-wrap"><table class="classes">\n<tbody>\n');
for k=1:numel(classes)
    if isempty(ids)
        rowId = '';
    else
        rowId = sprintf(' id="%s"',esc(ids{k}));
    end
    fprintf(fp,'<tr%s><td><a href="%s"><code>%s</code></a></td><td>%s</td></tr>\n',...
        rowId,pageName(classes{k}),esc(char(classes{k}.classname)),esc(char(classes{k}.classdescription)));
end
fprintf(fp,'</tbody>\n</table></div>\n');

% The file name of the page of a class or struct
function fn = pageName(params)
if isfield(params,'parentclassname')
    fn = [params.parentclassname '_' char(params.classname) '.html'];
else
    fn = [char(params.classname) '.html'];
end

% What kind of thing a page describes
function kind = pageKind(params)
kind = 'Section';
if isfield(params,'parentclassname')
    parent = params.parentclassname;
    if ~isempty(regexp(parent,'client$','once'))
        kind = 'Recording device';
    elseif strcmp(parent,'stimulus')
        kind = 'Stimulus';
    elseif strcmp(parent,'response')
        kind = 'Response';
    elseif strcmp(parent,'start')
        kind = 'Trial start';
    elseif strcmp(parent,'staircase')
        kind = 'Staircase';
    end
end

% Make the page for one class or struct
function fn = makeIndividualPage(params,usedIn,fieldName)
fn = pageName(params);
fp = fopen(['docs/protocolDocumentation/' fn],'w');
usedIn.field = fieldName;
openPage(fp,char(params.classname),pageKind(params),usedIn);
fprintf(fp,'<p class="lead">%s</p>\n',esc(char(params.classdescription)));
if isfield(params,'showPositionValues')
    fprintf(fp,'<h2 id="showing-the-position">Showing the position</h2>\n');
    fprintf(fp,'<p>With <code>showPosition</code> = 3, 4 or 5 in a trial, the position of the dot is calculated from the values of the device using ');
    fprintf(fp,'<a href="#displayRangeX"><code>displayRangeX</code></a> and <a href="#displayRangeY"><code>displayRangeY</code></a>.</p>\n');
    fprintf(fp,'<p>%s</p>\n',esc(params.showPositionValues));
    fprintf(fp,'<p>The sizes are checked by <code>validate</code>.</p>\n');
    fprintf(fp,'<h2 id="options">Options</h2>\n');
end
makeTable(fp,params,struct('file',fn,'title',char(params.classname),'prefix','','summarize',0));
closePage(fp);
fclose(fp);

function makeTable(fp,params,thisPage)

thefields = fields(params);
for k=1:numel(thefields)
    if ~any(strcmp({'name','type','description','required','default','classname','classdescription','parentclassname','showPositionValues'},thefields{k}))
        error(['Unknown field ' thefields{k} ' in ' params.classname]);
    end
end

% the options of the parent class, its parent, ... (e.g. forcesensors -> DAQclient -> socketclient)
ancestors = getAncestorParams(params);
nInherited = 0;
for a=1:numel(ancestors)
    nInherited = nInherited + numel(ancestors{a}.name);
end

if isempty(params.name) && nInherited==0
    fprintf(fp,'<p class="empty">This has no options.</p>\n');
    return;
end

fprintf(fp,'<div class="table-wrap"><table class="params">\n');
fprintf(fp,'<thead><tr><th>Name</th><th>Type</th><th>Default</th><th>Description</th></tr></thead>\n');
groups = [{params} ancestors];
documented = {};
for j=1:numel(groups)
    p = groups{j};
    if isempty(p.name)
        continue;
    end
    if j==1
        if nInherited>0
            fprintf(fp,'<tbody><tr class="group"><th colspan="4">Options of %s</th></tr>\n',esc(char(params.classname)));
        else
            fprintf(fp,'<tbody>\n');
        end
    elseif j==numel(groups)
        % the options of the base class (e.g. socketclient) apply to the whole kind
        fprintf(fp,'<tbody class="inherited"><tr class="group"><th colspan="4">Options of all %ss (from %s)</th></tr>\n',...
            lower(pageKind(params)),esc(groups{j-1}.parentclassname));
    else
        fprintf(fp,'<tbody class="inherited"><tr class="group"><th colspan="4">Options from %s</th></tr>\n',...
            esc(groups{j-1}.parentclassname));
    end
    for k=1:numel(p.name)
        if strcmp(p.type{k},'ignore')
            continue;
        end
        t = p.type{k};
        if thisPage.summarize && isstruct(t) && isfield(t,'parentclassname') && ~isempty(regexp(t.parentclassname,'client$','once'))
            % devices are listed in their own section of the index
            makeIndividualPage(t,thisPage,p.name{k});
            continue;
        end
        required = p.required(k);
        if iscell(required)
            required = required{1};
        end
        if any(strcmp(documented,p.name{k}))
            rowId = ''; % also defined further up (that row has the anchor)
        else
            rowId = sprintf(' id="%s%s"',thisPage.prefix,esc(p.name{k}));
            documented{end+1} = p.name{k}; %#ok<AGROW>
        end
        fprintf(fp,'<tr%s><td class="name"><code>%s</code>%s</td>',rowId,esc(p.name{k}),requiredLabel(required));
        sections = struct('stimulus',{{'stimuli','stimuli'}},'targetType',{{'responses','responses'}},'starttrial',{{'starts','trial starts'}});
        if thisPage.summarize && iscell(t) && isfield(sections,p.name{k})
            typeText(t,thisPage,p.name{k}); % writes the pages
            sec = sections.(p.name{k});
            fprintf(fp,'<td class="type">one of the <a href="#%s">%s</a></td>',sec{1},sec{2});
        else
            fprintf(fp,'<td class="type">%s</td>',typeText(t,thisPage,p.name{k}));
        end
        fprintf(fp,'<td class="default">%s</td>',defaultText(p.type{k},p.default{k}));
        fprintf(fp,'<td>%s</td></tr>\n',esc(p.description{k}));
    end
    fprintf(fp,'</tbody>\n');
end
fprintf(fp,'</table></div>\n');

function s = requiredLabel(required)
labels = {'','required','zero or more','one or more'};
if required==0
    s = '';
else
    s = sprintf('<span class="req req%d">%s</span>',required,labels{required+1});
end

function s = typeText(t,thisPage,fieldName)
if isstruct(t)
    fn = makeIndividualPage(t,thisPage,fieldName);
    s = sprintf('<a href="%s">struct</a>',fn);
elseif iscell(t)
    links = cell(1,numel(t));
    for m=1:numel(t)
        fn = makeIndividualPage(t{m},thisPage,fieldName);
        links{m} = sprintf('<a href="%s">%s</a>',fn,esc(char(t{m}.classname)));
    end
    s = ['one of: ' strjoin(links,', ')];
elseif strcmp(t,'number')
    s = '<abbr title="A single number (not a matrix)">number</abbr>';
elseif strcmp(t,'boolean')
    s = '<abbr title="0 / 1 (false / true)">boolean</abbr>';
elseif strcmp(t,'integer')
    s = '<abbr title="A single integer (not a matrix)">integer</abbr>';
elseif strcmp(t,'matrix')
    s = '<abbr title="A matrix (see the description for how to fill it)">matrix</abbr>';
elseif strcmp(t,'integermatrix')
    s = '<abbr title="A matrix of integers (see the description for how to fill it)">integer matrix</abbr>';
elseif strncmp(t,'matrix_',7)
    r = regexp(t,'matrix_([n0-9]*)_([n0-9]*)','tokens');
    s = sprintf('<abbr title="A %s by %s matrix (see the description for how to fill it)">%s&times;%s matrix</abbr>',...
        r{1}{1},r{1}{2},r{1}{1},r{1}{2});
elseif strcmp(t,'cellarray')
    s = '<abbr title="A cell array, e.g. {''a.png'',''b.png''}">cell array</abbr>';
else
    s = esc(t);
end

function s = defaultText(t,d)
if isempty(d)
    s = '<span class="none">&ndash;</span>';
    return;
elseif iscell(t)
    s = esc(char(d.classname));
elseif ischar(d)
    s = ['''' esc(d) ''''];
elseif strcmp(t,'boolean')
    if d==0
        s = 'false';
    else
        s = 'true';
    end
elseif isnumeric(d) && numel(d)>1
    s = matrixText(d);
elseif isstruct(d)
    f = fields(d);
    parts = cell(1,numel(f));
    for m=1:numel(f)
        parts{m} = [esc(f{m}) ': ' numberText(d.(f{m}))];
    end
    s = strjoin(parts,'<br>');
elseif iscell(d)
    parts = cell(1,numel(d));
    for m=1:numel(d)
        if isnumeric(d{m}) && numel(d{m})==1
            parts{m} = numberText(d{m});
        elseif isnumeric(d{m})
            parts{m} = matrixText(d{m});
        else
            parts{m} = ['''' esc(d{m}) ''''];
        end
    end
    s = ['{' strjoin(parts,', ') '}'];
else
    s = numberText(d);
end
s = ['<code>' s '</code>'];

function s = matrixText(d)
rows = cell(1,size(d,1));
for r=1:size(d,1)
    parts = cell(1,size(d,2));
    for c=1:size(d,2)
        parts{c} = numberText(d(r,c));
    end
    rows{r} = strjoin(parts,' ');
end
s = ['[' strjoin(rows,'; ') ']'];

function s = numberText(x)
if isnan(x)
    s = 'NaN';
elseif isinf(x)
    if x>0
        s = 'Inf';
    else
        s = '-Inf';
    end
elseif round(x)==x
    s = sprintf('%d',x);
else
    s = sprintf('%g',x);
end

% Escape text for HTML
function s = esc(s)
if iscell(s)
    s = strjoin(cellfun(@esc,s,'UniformOutput',false),', ');
    return;
elseif ~ischar(s)
    s = num2str(s);
end
s = strrep(s,'&','&amp;');
s = strrep(s,'<','&lt;');
s = strrep(s,'>','&gt;');
s = strrep(s,'"','&quot;');

function openPage(fp,title,kind,usedIn)
fprintf(fp,'<!DOCTYPE html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n');
fprintf(fp,'<meta name="viewport" content="width=device-width, initial-scale=1">\n');
if isempty(kind)
    fprintf(fp,'<title>%s &ndash; Repeated Measures</title>\n',esc(title));
else
    fprintf(fp,'<title>%s (%s) &ndash; Repeated Measures</title>\n',esc(title),lower(kind));
end
fprintf(fp,'<link rel="stylesheet" href="style.css">\n</head>\n<body>\n');
fprintf(fp,'<header class="site"><div class="wrap"><a class="home" href="../index.html">Repeated Measures</a>');
fprintf(fp,'<span class="sep">/</span><a href="index.html">Protocol reference</a></div></header>\n');
fprintf(fp,'<main class="wrap">\n');
if ~isempty(kind)
    fprintf(fp,'<p class="kind">%s</p>\n',kind);
end
fprintf(fp,'<h1>%s</h1>\n',esc(title));
if ~isempty(usedIn)
    link = sprintf('%s#%s%s',usedIn.file,usedIn.prefix,esc(usedIn.field));
    if strcmp(usedIn.file,'index.html')
        where = [strrep(usedIn.prefix,'-','') '.' esc(usedIn.field)];
        if strcmp(where(1:5),'trial')
            where = ['trial{n}' where(6:end)];
        end
        fprintf(fp,'<p class="used-in">Used in <a href="%s"><code>%s</code></a></p>\n',link,where);
    else
        fprintf(fp,'<p class="used-in">Used in <a href="%s"><code>%s</code></a> of <a href="%s">%s</a></p>\n',...
            link,esc(usedIn.field),usedIn.file,esc(usedIn.title));
    end
end

function closePage(fp)
fprintf(fp,'</main>\n<footer class="site"><div class="wrap">Generated by <code>makeProtocolDocumentation</code>. ');
fprintf(fp,'<a href="https://github.com/JasonFriedman/RepeatedMeasures">Repeated Measures on GitHub</a></div></footer>\n');
fprintf(fp,'</body>\n</html>\n');

function writeStylesheet(filename)
css = {
    ':root {'
    '  --bg: #fdfdfc; --text: #1f2422; --muted: #626b67; --line: #e1e4e1;'
    '  --head: #f3f4f2; --accent: #1f6f5c; --code: #f1f3f0; --req: #8a4b14;'
    '}'
    '@media (prefers-color-scheme: dark) {'
    '  :root {'
    '    --bg: #161a18; --text: #e3e7e4; --muted: #9aa49f; --line: #2f3633;'
    '    --head: #1e2321; --accent: #72c4ab; --code: #232927; --req: #e0a36b;'
    '  }'
    '}'
    '* { box-sizing: border-box; }'
    'body { margin: 0; background: var(--bg); color: var(--text);'
    '  font: 16px/1.55 -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; }'
    'a { color: var(--accent); text-underline-offset: 2px; }'
    '.wrap { max-width: 1080px; margin: 0 auto; padding: 0 24px; }'
    'header.site { border-bottom: 1px solid var(--line); padding: 14px 0; font-size: 15px; }'
    'header.site a { text-decoration: none; }'
    'header.site .home { font-weight: 600; color: var(--text); }'
    'header.site .sep { color: var(--muted); margin: 0 10px; }'
    'main { padding-top: 40px; padding-bottom: 48px; }'
    'h1 { font-size: 32px; line-height: 1.2; margin: 0 0 12px; letter-spacing: -0.01em; }'
    'h2 { font-size: 22px; margin: 44px 0 10px; padding-top: 8px; }'
    'p { margin: 0 0 12px; max-width: 760px; }'
    '.kind { margin: 0 0 4px; color: var(--muted); font-size: 14px; text-transform: uppercase; letter-spacing: 0.06em; }'
    '.lead { font-size: 18px; color: var(--muted); }'
    '.used-in { color: var(--muted); font-size: 15px; }'
    '.empty { color: var(--muted); font-style: italic; }'
    'code { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size: 0.9em; }'
    'p code, li code { background: var(--code); padding: 1px 5px; border-radius: 3px; }'
    'pre { background: var(--code); border: 1px solid var(--line); border-radius: 6px; padding: 14px 16px;'
    '  overflow-x: auto; font-size: 14px; line-height: 1.5; max-width: 860px; }'
    'pre code { font-size: 1em; }'
    'nav.toc ul { list-style: none; padding: 0; margin: 16px 0 8px; display: flex; flex-wrap: wrap; gap: 6px 22px; }'
    'nav.toc a { text-decoration: none; }'
    'nav.toc a:hover { text-decoration: underline; }'
    '.table-wrap { overflow-x: auto; margin: 12px 0 8px; }'
    'table { border-collapse: collapse; width: 100%; font-size: 15px; }'
    'th, td { text-align: left; vertical-align: top; padding: 9px 12px; border-bottom: 1px solid var(--line); }'
    'thead th { background: var(--head); font-size: 13px; text-transform: uppercase; letter-spacing: 0.05em;'
    '  color: var(--muted); font-weight: 600; border-bottom: 1px solid var(--line); }'
    'tr.group th { background: transparent; font-weight: 600; font-size: 14px; color: var(--muted);'
    '  padding-top: 18px; text-transform: none; letter-spacing: 0; }'
    'tbody.inherited td { color: var(--muted); }'
    'td.name { white-space: nowrap; }'
    'td.name code { font-weight: 600; color: var(--text); }'
    'td.type, td.default { white-space: nowrap; }'
    'td.type { color: var(--muted); }'
    'td.type a { white-space: normal; }'
    'td.type abbr { white-space: nowrap; }'
    'table.params td.type { max-width: 260px; white-space: normal; }'
    'td.default code { white-space: nowrap; }'
    'abbr { text-decoration: underline dotted; text-underline-offset: 3px; cursor: help; }'
    '.none { color: var(--muted); }'
    '.req { display: block; font-size: 12px; color: var(--req); margin-top: 2px; }'
    'table.classes td:first-child { white-space: nowrap; width: 1%; padding-right: 28px; }'
    'table.classes code { font-weight: 600; }'
    'tr:target td { background: var(--code); }'
    'footer.site { border-top: 1px solid var(--line); padding: 18px 0 40px; color: var(--muted); font-size: 14px; }'
    '@media (max-width: 640px) {'
    '  h1 { font-size: 26px; }'
    '  .wrap { padding: 0 16px; }'
    '  th, td { padding: 8px 8px; }'
    '  table.params thead { display: none; }'
    '  table.params, table.params tbody, table.params tr, table.params td, table.params th { display: block; width: auto; }'
    '  table.params tr { border-bottom: 1px solid var(--line); padding: 10px 0; }'
    '  table.params td, table.params th { border: 0; padding: 2px 0; }'
    '  table.params tr.group { padding: 16px 0 4px; }'
    '  table.params td.name .req { display: inline; margin-left: 8px; }'
    '  table.params td.type, table.params td.default { display: inline-block; max-width: none; margin-right: 14px; font-size: 14px; }'
    '  table.params td.default::before { content: "default "; color: var(--muted); font-size: 13px; }'
    '  table.classes td:first-child { padding-right: 12px; }'
    '}'};
fp = fopen(filename,'w');
fwrite(fp,sprintf('%s\n',css{:}));
fclose(fp);
