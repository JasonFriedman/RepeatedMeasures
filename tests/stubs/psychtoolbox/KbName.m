% KBNAME - stub: converts between key names and key codes (USB HID usage codes, as
% used by Psychtoolbox after KbName('UnifyKeyNames'))
function out = KbName(in)
persistent names
if isempty(names)
    names = cell(1,256);
    for k=1:26
        names{3+k} = char('a'+k-1);
    end
    digits = '1234567890';
    for k=1:10
        names{29+k} = digits(k);
    end
    names{40} = 'Return'; names{41} = 'ESCAPE'; names{42} = 'DELETE'; names{43} = 'tab';
    names{44} = 'space'; names{79} = 'RightArrow'; names{80} = 'LeftArrow';
    names{81} = 'DownArrow'; names{82} = 'UpArrow';
end
if nargin==0
    out = names;
elseif ischar(in)
    if any(strcmpi(in,{'UnifyKeyNames','KeyNames','KeyNamesOSX','KeyNamesWindows','KeyNamesLinux'}))
        out = names;
        return;
    end
    out = find(strcmpi(names,in));
    if isempty(out)
        error('KbName stub: unknown key name %s',in);
    end
    out = out(1);
elseif iscell(in)
    out = zeros(1,numel(in));
    for k=1:numel(in)
        out(k) = KbName(in{k});
    end
elseif islogical(in) || (numel(in)==256 && all(in==0 | in==1))
    pressed = find(in);
    if isempty(pressed)
        out = '';
    elseif numel(pressed)==1
        out = names{pressed};
    else
        out = names(pressed);
    end
else
    if numel(in)==1
        out = names{in};
    else
        out = names(in);
    end
end
