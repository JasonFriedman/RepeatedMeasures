% PROTOCOLOPTIONS - show the options that can be used in a protocol
%
% protocolOptions                   overview: devices, stimuli, responses, starts
% protocolOptions('setup')          parameters of the setup section
% protocolOptions('trial')          parameters of a trial
% protocolOptions('tablet')         parameters of a device, stimulus, response or start
% protocolOptions('stimulus')       list of the stimuli (also 'devices', 'targetType',
%                                   'starttrial', 'staircases')
% protocolOptions('stimulus.images')            when a name is used more than once
% protocolOptions('images.stateTransitions')    parameters of a nested struct
% protocolOptions('trial.beep')
% list = protocolOptions(...)       return the parameters instead of printing them
%
% The information comes from the code (see protocolSchema), so it is always up to date.
function varargout = protocolOptions(what)
schema = protocolSchema;
groups = {'devices','stimulus','targetType','starttrial','staircases'};
if nargin<1 || isempty(what)
    fprintf('A protocol has a setup section, an optional common section and a list of trials.\n');
    fprintf('Use protocolOptions(''setup''), protocolOptions(''trial'') or protocolOptions(name) for details.\n');
    for k=1:numel(groups)
        printGroup(schema,groups{k});
    end
    return;
end
parts = regexp(what,'\.','split');
if any(strcmp(parts{1},groups)) && numel(parts)==1
    printGroup(schema,parts{1});
    return;
end
[params,title] = findParams(schema,parts);
if nargout>0
    varargout{1} = params;
    return;
end
fprintf('\n%s\n',title);
printParams(params);

function printGroup(schema,group)
names = fieldnames(schema.(group));
fprintf('\n%s:\n',group);
for k=1:numel(names)
    fprintf('  %-28s %s\n',names{k},firstSentence(schema.descriptions.(group).(names{k})));
end

function [params,title] = findParams(schema,parts)
groups = {'devices','stimulus','targetType','starttrial','staircases'};
if strcmp(parts{1},'setup') || strcmp(parts{1},'trial')
    params = schema.(parts{1});
    title = parts{1};
    rest = parts(2:end);
elseif any(strcmp(parts{1},groups)) || strcmp(parts{1},'device')
    group = parts{1};
    if strcmp(group,'device')
        group = 'devices';
    end
    if ~isfield(schema.(group),parts{2})
        error('There is no %s called %s.%s',group,parts{2},pbSuggest(parts{2},fieldnames(schema.(group))));
    end
    params = schema.(group).(parts{2});
    title = sprintf('%s %s: %s',group,parts{2},schema.descriptions.(group).(parts{2}));
    rest = parts(3:end);
else
    found = {};
    for k=1:numel(groups)
        if isfield(schema.(groups{k}),parts{1})
            found{end+1} = groups{k}; %#ok<AGROW>
        end
    end
    if isempty(found)
        all = {};
        for k=1:numel(groups)
            all = [all; fieldnames(schema.(groups{k}))]; %#ok<AGROW>
        end
        error('Unknown name %s.%s',parts{1},pbSuggest(parts{1},all));
    elseif numel(found)>1
        fprintf('(%s is the name of a %s. Showing the %s; use e.g. protocolOptions(''%s.%s'') for the other)\n',...
            parts{1},strjoin(found,' and a '),found{1},found{2},parts{1});
    end
    params = schema.(found{1}).(parts{1});
    title = sprintf('%s %s: %s',found{1},parts{1},schema.descriptions.(found{1}).(parts{1}));
    rest = parts(2:end);
end
for k=1:numel(rest)
    idx = find(strcmp({params.name},rest{k}));
    if isempty(idx)
        error('%s has no parameter %s.%s',title,rest{k},pbSuggest(rest{k},{params.name}));
    end
    child = params(idx).children;
    if isempty(child)
        params = params(idx);
    elseif isstruct(child) && ~isfield(child,'name')
        % a "one of": list the options, or descend into one of them
        if k<numel(rest) && isfield(child,rest{k+1})
            params = child.(rest{k+1});
            title = [title '.' rest{k} '.' rest{k+1}]; %#ok<AGROW>
            break;
        end
        fprintf('\n%s.%s is one of: %s\n',title,rest{k},strjoin(fieldnames(child)',', '));
        params = params(idx);
    else
        params = child;
    end
    title = [title '.' rest{k}]; %#ok<AGROW>
end

function printParams(params)
requiredText = {'','required','0 or more','1 or more'};
for k=1:numel(params)
    p = params(k);
    if strcmp(p.type,'ignore')
        continue;
    end
    t = p.type;
    if strcmp(t,'oneof')
        t = 'one of (see below)';
    end
    fprintf('  %-26s %-16s %-10s default: %s\n',p.name,t,requiredText{p.required+1},pbValueToText(p.default));
    fprintf('      %s\n',p.description);
    if strcmp(p.type,'oneof')
        fprintf('      options: %s\n',strjoin(fieldnames(p.children)',', '));
    elseif strcmp(p.type,'struct')
        fprintf('      fields: %s\n',strjoin({p.children.name},', '));
    end
end

function s = firstSentence(s)
idx = find(s=='.',1);
if ~isempty(idx) && idx>20
    s = s(1:idx);
end
if numel(s)>110
    s = [s(1:107) '...'];
end
