% Show the last position recorded as a dot on the screen (e.g. mouse or tablet position)

function [lastposition,thistrial] = showPosition(tc,thistrial,experimentdata,e,frame)
% get the current position
lastsample = getsample(tc);
% i.e. pressure > 0 or always showing
if lastsample(4)>0 || ~tc.showPositionOnlyWhenTouching
    lasts = lastsample;
else
    lastposition = [NaN NaN];
    return;
end
x = lasts(1) * experimentdata.screenInfo.screenRect(3);
y = (1-lasts(2)) * experimentdata.screenInfo.screenRect(4);
lastposition = [x y];
% If movementonset=1, then movement onset requires a movement in the last frame of greater than 0.005
% If movementonset=2, then pressure>0 is sufficient
if ~isempty(thistrial.movementonset) && thistrial.movementonset.type<0
    if (thistrial.movementonset.type==-1 && ~isempty(thistrial.lastx) && ((thistrial.lastx - x)^2 + (thistrial.lasty - y)^2) > 0.005) || ...
            thistrial.movementonset.type==-2
        thistrial.movementonset.type = frame;
    end
end
thistrial.lastx = x;
thistrial.lasty = y;

if size(tc.showPositionColor,1)==2
    if lastsample(4) > 0
        therow = 1;
    else
        therow = 2;
    end
else
    therow = 1;
end

if strcmp(tc.showPositionType,'dot')
    if thistrial.showPosition==1 || (thistrial.showPosition==2 && isa(thistrial.thisstimulus,'imagesstimulus') && thistrial.imageState == 1)
        Screen('DrawDots', experimentdata.screenInfo.curWindow, [x;y], 6, tc.showPositionColor(therow,:),[],1);
    end
% The rectangle only shows the y position
elseif strcmp(tc.showPositionType,'rectangle')
    left = 0.55 * experimentdata.screenInfo.screenRect(3);
    top = y;
    height = 0.9 * experimentdata.screenInfo.screenRect(4) - y;
    if height<0
        height = 0;
    end
    width = 0.15 * experimentdata.screenInfo.screenRect(3);
    rect = [left top left+width top+height];
    Screen('FillRect', experimentdata.screenInfo.curWindow, tc.showPositionColor(therow,:), rect);
else
    error(['Unknown showPositionType: ' tc.showPositionType]);
end
