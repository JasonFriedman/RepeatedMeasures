% Show the last position recorded as a dot on the screen 
% If showPosition (set per trial) =1 -> show the actual position of the stylus on the tablet
%                                 =2 -> do nothing (for compatibility with liberty / force sensors)
%                                 =3 -> calculate position based on displayRangeX / displayRangeY / offsetX / offsetY

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

lastsample(2) = 1 - lastsample(2); % make y the usual way around

if thistrial.showPosition==3
    k=1; % only need one row (because only one mouse)
    lastposition(1) = tc.offsetX;
    lastposition(2) = tc.offsetY;
    for n=1:2
        if tc.displayRangeX(k,n*2) ~= tc.displayRangeX(k,n*2-1)
            lastposition(1) = lastposition(1) + (lastsample(n) - tc.displayRangeX(k,n*2-1)) / (tc.displayRangeX(k,n*2) - tc.displayRangeX(k,n*2-1));
        end
        if tc.displayRangeY(k,n*2) ~= tc.displayRangeY(k,n*2-1)
            lastposition(2) = lastposition(2) + (lastsample(n) - tc.displayRangeY(k,n*2-1)) / (tc.displayRangeY(k,n*2) - tc.displayRangeY(k,n*2-1));
        end
    end
    if tc.displayRangeX(k,5) ~= 0
        if isfield(thistrial,'StimulusOnsetTime')
            lastposition(1) = lastposition(1) + tc.displayRangeX(k,5) * (GetSecs - thistrial.StimulusOnsetTime(1));
        end
    end
    if tc.displayRangeY(k,5) ~= 0
        if isfield(thistrial,'StimulusOnsetTime')
            lastposition(2) = lastposition(2) + tc.displayRangeY(k,5) * (GetSecs - thistrial.StimulusOnsetTime(1));
        end
    end
    lastsample(1) = lastposition(1);
    lastsample(2) = lastposition(2);
end

lastposition(1) = lastsample(1) * experimentdata.screenInfo.screenRect(3);
lastposition(2) = lastsample(2) * experimentdata.screenInfo.screenRect(4);

% If movementonset=1, then movement onset requires a movement in the last frame of greater than 0.005
% If movementonset=2, then pressure>0 is sufficient
if ~isempty(thistrial.movementonset) && thistrial.movementonset.type<0
    if (thistrial.movementonset.type==-1 && ~isempty(thistrial.lastx) && ((thistrial.lastx - lastposition(1))^2 + (thistrial.lasty - lastposition(2))^2) > 0.005) || ...
            thistrial.movementonset.type==-2
        thistrial.movementonset.type = frame;
    end
end

thistrial.lastx = lastposition(1);
thistrial.lasty = lastposition(2);

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
    if any(thistrial.showPosition==[1 3]) || (thistrial.showPosition==2 && isa(thistrial.thisstimulus,'imagesstimulus') && thistrial.imageState == 1)
        Screen('DrawDots', experimentdata.screenInfo.curWindow, lastposition, tc.showPositionSize, tc.showPositionColor(therow,:),[],1);
    end
elseif strcmp(tc.showPositionType,'ellipse')
    % left top right bottom (4xN matrix)
    rect = [lastposition(1) - tc.showPositionSize(1)/2;
        lastposition(2) - tc.showPositionSize(2)/2;
        lastposition(1) + tc.showPositionSize(1)/2;
        lastposition(2) + tc.showPositionSize(2)/2];
    Screen('FillOval', experimentdata.screenInfo.curWindow, tc.showPositionColor, rect);
% The rectangle only shows the y position
elseif strcmp(tc.showPositionType,'rectangle')
    left = 0.55 * experimentdata.screenInfo.screenRect(3);
    top = lastposition(2);
    height = 0.9 * experimentdata.screenInfo.screenRect(4) - lastposition(2);
    if height<0
        height = 0;
    end
    width = 0.15 * experimentdata.screenInfo.screenRect(3);
    rect = [left top left+width top+height];
    Screen('FillRect', experimentdata.screenInfo.curWindow, tc.showPositionColor(therow,:), rect);
else
    error(['Unknown showPositionType: ' tc.showPositionType]);
end
