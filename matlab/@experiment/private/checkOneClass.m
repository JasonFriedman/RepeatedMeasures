% CHECKONECLASS - check the stimulus / targetType / starttrial section of a trial
%
% name = checkOneClass(value,field,suffix,trialOptions)
%
% value is e.g. trial{n}.stimulus, which must contain exactly one entry: the name of a
% stimulus (class <name>stimulus) with its options. Anything else is reported, with a
% hint when it looks like a trial option put in the wrong place, e.g.
%   trial{n}.stimulus.showText.text = 'Hi';
%   trial{n}.stimulus.startTrial = 'keyboard';   % should be trial{n}.starttrial
% Returns the name (e.g. 'showText').

function name = checkOneClass(value,field,suffix,trialOptions)

given = fields(value);
for k=1:numel(given)
    if exist([given{k} suffix],'file')
        continue;
    end
    hint = suggestName(given{k},trialOptions);
    if ~isempty(hint)
        hint = sprintf(' It looks like a trial option: did you mean trial{n}.%s rather than trial{n}.%s.%s?',...
            strtrim(regexprep(hint,'^ Did you mean (.*)\?$','$1')),field,given{k});
    else
        hint = suggestName(given{k},listClasses(suffix));
    end
    error('%s.%s: there is no %s called %s.%s',field,given{k},suffix,given{k},hint);
end
if numel(given)~=1
    error('%s should contain exactly one %s, but it contains %s',field,suffix,strjoin(given',', '));
end
name = given{1};

function names = listClasses(suffix)
d = dir([fileparts(fileparts(fileparts(mfilename('fullpath')))) '/@*' suffix]);
names = regexprep({d.name},['^@(.*)' suffix '$'],'$1');
