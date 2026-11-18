% DRAWFORMATTEDTEXT - stub: records the text, returns plausible bounds
function [nx,ny,textbounds] = DrawFormattedText(win,tstring,varargin)
w = rmtestWorld;
w.texts{end+1} = tstring;
if ~isfield(w.calls,'DrawFormattedText')
    w.calls.DrawFormattedText = 0;
end
w.calls.DrawFormattedText = w.calls.DrawFormattedText + 1;
rmtestWorld(w);
lines = regexp(char(tstring),'\\n|\n','split');
width = max(cellfun(@numel,lines)) * 10;
height = numel(lines) * 20;
nx = width; ny = height;
textbounds = [0 0 max(width,1) max(height,1)];
