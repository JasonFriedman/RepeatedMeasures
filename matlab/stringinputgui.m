% STRINGINPUTGUI - return a string
%
% result = stringinputgui(title,question,defaultvalue)
% title and question are required, default is optional
function result = stringinputgui(title,question,defaultvalue)

if nargin<2
    error('Must provide 2 arguments: title and question');
end

if nargin<3 || isempty(defaultvalue)
    defaultvalue = '';
end

% Returns a string
result = []; % Default, in case user closes GUI.

f = figure('units','pixels',...
    'position',[500 500 210 90],...
    'menubar','none','numbertitle','off','name',title,'resize','off');

uicontrol('style','text','units','pixels',...
    'position',[10 65 180 20],...
    'backgroundcolor',get(f,'color'),'horizontalalignment','left',...
    'string',question);

editbox = uicontrol('style','edit','units','pixels',...
    'position',[10 35 190 30],'horizontalalignment','left',...
    'keypressfcn',{@keypressed},'string',defaultvalue);
    
OKbutton = uicontrol('style','pushbutton','units','pixels',...
    'position',[95 5 50 25],'string','OK',... 
    'callback',{@submit});

uicontrol('style','pushbutton','units','pixels',... % cancel button
    'position',[150 5 50 25],'string','Cancel',... 
    'callback',{@submit});

uicontrol(editbox) % Put blinking cursor in edit box.
uiwait(f) % Wait till the GUI closes.
drawnow;

    function submit(src,varargin)
        if src==OKbutton
            result = get(editbox,'String');
        end
        % If it is the cancel button, don't return anything
        close(f);
    end

    function keypressed(~,varargin)
        if strcmp(varargin{1}.Key,'return')
            drawnow;
            result = get(editbox,'String');
            close(f);
        end
    end
end