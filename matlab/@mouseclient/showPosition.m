% SHOWPOSITION - show the position for the mouse (as a dot)

function [lastposition,thistrial] = showPosition(m,thistrial,experimentdata,e,frame)
% get the current position
lastsample = getsample(m);
lastposition(1) = lastsample(1) * experimentdata.screenInfo.screenRect(3);
lastposition(2) = (1-lastsample(2)) * experimentdata.screenInfo.screenRect(4);

if strcmp(m.showPositionType,'dot')
    Screen('DrawDots', experimentdata.screenInfo.curWindow, lastposition, 6, [192 192 192],[],1);
elseif strcmp(m.showPositionType,'rectangle')
    left = 0.55 * experimentdata.screenInfo.screenRect(3);
    top = lastposition(2);
    height = 0.9 * experimentdata.screenInfo.screenRect(4) - top;
    width = 0.15 * experimentdata.screenInfo.screenRect(3);
    rect = [left top left+width top+height];
    Screen('FillRect', experimentdata.screenInfo.curWindow, m.showPositionColor, rect);
else
    error(['Unknown showPositionType: ' tc.showPositionType]);
end

