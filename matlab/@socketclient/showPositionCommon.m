% SHOWPOSITION - show the position for various devices (including mouse + tablet)
% If showPosition (set per trial) =1 -> show the actual position of the device
%                                 =2 -> do nothing (for compatibility with liberty / force sensors)
%                                 =3 -> calculate position based on displayRangeX / displayRangeY / offsetX / offsetY

function [lastposition,thistrial] = showPositionCommon(m,lastsample,thistrial,experimentdata,e,frame)

[lastsample,thistrial] = calculateLastPosition(m,lastsample,thistrial);

lastposition(1) = lastsample(1) * experimentdata.screenInfo.screenRect(3);
lastposition(2) = lastsample(2) * experimentdata.screenInfo.screenRect(4);

if iscell(m.showPositionColor)
    thisShowPositionColor = m.showPositionColor{thistrial.trialnum};
    if size(thisShowPositionColor,1)>2
        if frame > size(thisShowPositionColor,1)
            frame = size(thisShowPositionColor,1);
        end
        thisShowPositionColor = thisShowPositionColor(frame,:);
    end
    therow = 1;
else
    thisShowPositionColor = m.showPositionColor;

    % This is only relevant for the tablet, but should not effect the mouse
    % It is to show a different colour when the pen is touching (row 1) or not (row 2)

    if size(thisShowPositionColor,1)==2
        if lastsample(4) > 0
            therow = 1;
        else
            therow = 2;
        end
    else
        therow = 1;
    end

end


if strcmp(m.showPositionType,'dot')
    if any(thistrial.showPosition==[1 3]) || (thistrial.showPosition==2 && isa(thistrial.thisstimulus,'imagesstimulus') && thistrial.imageState == 1)
        Screen('DrawDots', experimentdata.screenInfo.curWindow, lastposition, m.showPositionSize, thisShowPositionColor,[],1);
    end
elseif strcmp(m.showPositionType,'ellipse')
    % left top right bottom (4xN matrix)
    rect = [lastposition(1) - m.showPositionSize(1)/2;
        lastposition(2) - m.showPositionSize(2)/2;
        lastposition(1) + m.showPositionSize(1)/2;
        lastposition(2) + m.showPositionSize(2)/2];
    Screen('FillOval', experimentdata.screenInfo.curWindow, thisShowPositionColor, rect);
elseif strcmp(m.showPositionType,'rectangle')
    left = 0.55 * experimentdata.screenInfo.screenRect(3);
    top = lastposition(2);
    height = 0.9 * experimentdata.screenInfo.screenRect(4) - top;
    if height<0
        height = 0;
    end
    width = 0.15 * experimentdata.screenInfo.screenRect(3);
    rect = [left top left+width top+height];
    Screen('FillRect', experimentdata.screenInfo.curWindow, thisShowPositionColor(therow,:), rect);
else
    error(['Unknown showPositionType: ' m.showPositionType]);
end

