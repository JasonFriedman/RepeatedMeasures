% SHOWPOSITION - show the position for the mouse (as a dot)

function [lastposition,thistrial] = showPosition(m,thistrial,experimentdata,e,frame)
% get the current position
lastsample = getsample(m);
lastposition(1) = lastsample(1) * experimentdata.screenInfo.screenRect(3);
lastposition(2) = (1-lastsample(2)) * experimentdata.screenInfo.screenRect(4);

Screen('DrawDots', experimentdata.screenInfo.curWindow, lastposition, 6, [192 192 192],[],1);
