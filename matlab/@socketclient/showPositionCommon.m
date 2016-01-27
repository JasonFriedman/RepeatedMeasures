% SHOWPOSITIONCOMMON - show the position for various devices (including mouse + tablet)
% If showPosition (set per trial) =1 -> show the actual position of the device
%                                 =2 -> do nothing (for compatibility with liberty / force sensors)
%                                 =3 -> calculate position based on displayRangeX / displayRangeY / offsetX / offsetY

function [lastposition,thistrial] = showPositionCommon(m,lastsample,thistrial,experimentdata,e,frame)

[lastsample,thistrial] = calculateLastPosition(m,lastsample,thistrial,frame);

lastposition(:,1) = lastsample(:,1) * experimentdata.screenInfo.screenRect(3);
lastposition(:,2) = lastsample(:,2) * experimentdata.screenInfo.screenRect(4);

thistrial.lastposition = lastposition;

if iscell(m.showPositionColor)
    thisShowPositionColor = m.showPositionColor{min([numel(m.showPositionColor) thistrial.trialnum])};
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

for p=1:size(lastposition,1)
    color = thisShowPositionColor(:,(p-1)*3+(1:3));
    
    if strcmp(m.showPositionType,'dot')
        if any(thistrial.showPosition==[1 3]) || (thistrial.showPosition==2 && isa(thistrial.thisstimulus,'imagesstimulus') && thistrial.imageState == 1)
            Screen('DrawDots', experimentdata.screenInfo.curWindow, lastposition(p,:), m.showPositionSize(p), color,[],1);
        end
    elseif strcmp(m.showPositionType,'ellipse')
        % left top right bottom (4xN matrix)
        rect = [lastposition(p,1) - m.showPositionSize(p,1)/2;
            lastposition(p,2) - m.showPositionSize(p,2)/2;
            lastposition(p,1) + m.showPositionSize(p,1)/2;
            lastposition(p,2) + m.showPositionSize(p,2)/2];
        Screen('FillOval', experimentdata.screenInfo.curWindow, color, rect);
    elseif strcmp(m.showPositionType,'rectangle')
        left = 0.55 * experimentdata.screenInfo.screenRect(3);
        top = lastposition(p,2);
        height = 0.9 * experimentdata.screenInfo.screenRect(4) - top;
        if height<0
            height = 0;
        end
        width = 0.15 * experimentdata.screenInfo.screenRect(3);
        rect = [left top left+width top+height];
        Screen('FillRect', experimentdata.screenInfo.curWindow, color(therow,:), rect);
    elseif strcmp(m.showPositionType,'image')
        imageNum = thisShowPositionColor(1);
        thissize = size(experimentdata.images{imageNum});
        % left top right bottom
        imagerectangle(1,1) = lastposition(1) - ceil(thissize(1)/2);
        imagerectangle(1,2) = lastposition(2) - floor(thissize(2)/2);
        imagerectangle(1,3) = imagerectangle(1,1) + thissize(1) - 1;
        imagerectangle(1,4) = imagerectangle(1,2) + thissize(2) - 1;
        Screen('DrawTexture',experimentdata.screenInfo.curWindow,experimentdata.textures(imageNum),[],imagerectangle);
    else
        error(['Unknown showPositionType: ' m.showPositionType]);
    end
end

