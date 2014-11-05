% SHOWPOSITION - show the position for various devices (including mouse + tablet)
% If showPosition (set per trial) =1 -> show the actual position of the device
%                                 =2 -> do nothing (for compatibility with liberty / force sensors)
%                                 =3 -> calculate position based on displayRangeX / displayRangeY / offsetX / offsetY

function [lastposition,thistrial] = showPositionCommon(m,lastsample,thistrial,experimentdata,e,frame)

displayRangeX = m.displayRangeX{min([numel(m.displayRangeX) thistrial.trialnum])};
displayRangeY = m.displayRangeY{min([numel(m.displayRangeY) thistrial.trialnum])};
showPositionRotationAngle = m.showPositionRotationAngle(min([numel(m.showPositionRotationAngle) thistrial.trialnum]));
showPositionRotationCenter = m.showPositionRotationCenter{min([numel(m.showPositionRotationCenter) thistrial.trialnum])};

if thistrial.showPosition==3
    
    k=1; % only need one row (because only one mouse)
    if numel(m.offsetX)==1
        lastposition(1) = m.offsetX;
    else
        lastposition(1) = m.offsetX(thistrial.trialnum);
    end
    if numel(m.offsetY)==1
        lastposition(2) = m.offsetY;
    else
        lastposition(2) = m.offsetY(thistrial.trialnum);
    end
    for n=1:2
        if displayRangeX(k,n*2) ~= displayRangeX(k,n*2-1)
            lastposition(1) = lastposition(1) + (lastsample(n) - displayRangeX(k,n*2-1)) / (displayRangeX(k,n*2) - displayRangeX(k,n*2-1));
        end
        if displayRangeY(k,n*2) ~= displayRangeY(k,n*2-1)
            lastposition(2) = lastposition(2) + (lastsample(n) - displayRangeY(k,n*2-1)) / (displayRangeY(k,n*2) - displayRangeY(k,n*2-1));
        end
    end
    if displayRangeX(k,5) ~= 0
        if isfield(thistrial,'StimulusOnsetTime')
            lastposition(1) = lastposition(1) + displayRangeX(k,5) * (GetSecs - thistrial.StimulusOnsetTime(1));
        end
    end
    if displayRangeY(k,5) ~= 0
        if isfield(thistrial,'StimulusOnsetTime')
            lastposition(2) = lastposition(2) + displayRangeY(k,5) * (GetSecs - thistrial.StimulusOnsetTime(1));
        end
    end
    lastsample(1) = lastposition(1);
    lastsample(2) = lastposition(2);
end

if ~isnan(showPositionRotationAngle) && showPositionRotationAngle~=0
    rotatedposition(1) = (lastsample(1) - showPositionRotationCenter(1)) * cos(showPositionRotationAngle) - (lastsample(2) - showPositionRotationCenter(2)) * sin(showPositionRotationAngle) + showPositionRotationCenter(1);
    rotatedposition(2) = (lastsample(1) - showPositionRotationCenter(1)) * sin(showPositionRotationAngle) + (lastsample(2) - showPositionRotationCenter(2)) * cos(showPositionRotationAngle) + showPositionRotationCenter(2);
    lastsample(1:2) = rotatedposition;
    thistrial.rotatedposition = rotatedposition;
end

lastposition(1) = lastsample(1) * experimentdata.screenInfo.screenRect(3);
lastposition(2) = lastsample(2) * experimentdata.screenInfo.screenRect(4);
% This is only relevant for the tablet, but should not effect the mouse
% It is to show a different colour when the pen is touching (row 1) or not (row 2)

if size(m.showPositionColor,1)==2
    if lastsample(4) > 0
        therow = 1;
    else
        therow = 2;
    end
else
    therow = 1;
end

if strcmp(m.showPositionType,'dot')
    if any(thistrial.showPosition==[1 3]) || (thistrial.showPosition==2 && isa(thistrial.thisstimulus,'imagesstimulus') && thistrial.imageState == 1)
        Screen('DrawDots', experimentdata.screenInfo.curWindow, lastposition, m.showPositionSize, m.showPositionColor,[],1);
    end
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
    if height<0
        height = 0;
    end
    width = 0.15 * experimentdata.screenInfo.screenRect(3);
    rect = [left top left+width top+height];
    Screen('FillRect', experimentdata.screenInfo.curWindow, m.showPositionColor(therow,:), rect);
else
    error(['Unknown showPositionType: ' m.showPositionType]);
end

