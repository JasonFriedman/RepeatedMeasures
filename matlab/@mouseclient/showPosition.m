% SHOWPOSITION - show the position for the mouse
% If showPosition (set per trial) =1 -> show the actual position of the mouse
%                                 =2 -> do nothing (for compatibility with liberty / force sensors)
%                                 =3 -> 

function [lastposition,thistrial] = showPosition(m,thistrial,experimentdata,e,frame)
% get the current position
lastsample = getsample(m);
lastsample(2) = 1 - lastsample(2); % make y the usual way around

if thistrial.showPosition==3
    k=1; % only need one row (because only one mouse)
    lastposition(1) = m.offsetX;
    lastposition(2) = m.offsetY;
    for n=1:2
        if m.displayRangeX(k,n*2) ~= m.displayRangeX(k,n*2-1)
            lastposition(1) = lastposition(1) + (lastsample(n) - m.displayRangeX(k,n*2-1)) / (m.displayRangeX(k,n*2) - m.displayRangeX(k,n*2-1));
        end
        if m.displayRangeY(k,n*2) ~= m.displayRangeY(k,n*2-1)
            lastposition(2) = lastposition(2) + (lastsample(n) - m.displayRangeY(k,n*2-1)) / (m.displayRangeY(k,n*2) - m.displayRangeY(k,n*2-1));
        end
    end
    if m.displayRangeX(k,5) ~= 0
        if isfield(thistrial,'StimulusOnsetTime')
            lastposition(1) = lastposition(1) + m.displayRangeX(k,5) * (GetSecs - thistrial.StimulusOnsetTime(1));
        end
    end
    if m.displayRangeY(k,5) ~= 0
        if isfield(thistrial,'StimulusOnsetTime')
            lastposition(2) = lastposition(2) + m.displayRangeY(k,5) * (GetSecs - thistrial.StimulusOnsetTime(1));
        end
    end
    lastsample(1) = lastposition(1);
    lastsample(2) = lastposition(2);
end

lastposition(1) = lastsample(1) * experimentdata.screenInfo.screenRect(3);
lastposition(2) = lastsample(2) * experimentdata.screenInfo.screenRect(4);

if strcmp(m.showPositionType,'dot')
    Screen('DrawDots', experimentdata.screenInfo.curWindow, lastposition, m.showPositionSize, m.showPositionColor,[],1);
elseif strcmp(m.showPositionType,'ellipse')
    % left top right bottom (4xN matrix)
    rect = [lastposition(1) - m.showPositionSize(1)/2;
        lastposition(2) - m.showPositionSize(2)/2;
        lastposition(1) + m.showPositionSize(1)/2;
        lastposition(2) + m.showPositionSize(2)/2];
    Screen('FillOval', experimentdata.screenInfo.curWindow, m.showPositionColor, rect);
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

