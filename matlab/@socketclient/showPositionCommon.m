% SHOWPOSITIONCOMMON - show the position for various devices (including mouse + tablet)
% If showPosition (set per trial) =1 -> show the actual position of the device
%                                 =2 -> if using image stimuli, only show position if in state 1
%                                 =3 -> calculate position based on displayRangeX / displayRangeY / offsetX / offsetY
%                                 =4 -> same as 3, but only before the trial starts
%                                 =5 -> same as 3, but if using image stimuli, only show position if in state 1
%
% Note that lastpositionVisual is the position on the screen (not in device coordinates)

function thistrial = showPositionCommon(m,lastpositionVisual,thistrial,experimentdata,e,frame)

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

for p=1:size(lastpositionVisual,1)
    color = thisShowPositionColor(:,(p-1)*3+(1:3));
    
    if strcmp(m.showPositionType,'dot')
        if any(thistrial.showPosition==[1 3]) || ...
                (any(thistrial.showPosition==[2 5]) && isa(thistrial.thisstimulus,'imagesstimulus') && thistrial.imageState == 1) || ...
                (thistrial.showPosition==4 && frame<1)
            if isfield(thistrial,'oldDots')
               if ~isnan(lastpositionVisual(p,1))
                   thistrial.oldDots{p} = [thistrial.oldDots{p} lastpositionVisual(p,:)'];
                   Screen('DrawDots', experimentdata.screenInfo.curWindow, thistrial.oldDots{p}, m.showPositionSize(p), color(therow,:),[],1);
               end
            else
                Screen('DrawDots', experimentdata.screenInfo.curWindow, lastpositionVisual(p,:), m.showPositionSize(p), color(therow,:),[],1);
            end
        end
    elseif strcmp(m.showPositionType,'line')
        if any(thistrial.showPosition==[1 3]) || ...
                (any(thistrial.showPosition==[2 5]) && isa(thistrial.thisstimulus,'imagesstimulus') && thistrial.imageState == 1) || ...
                (thistrial.showPosition==4 && frame<1)
            if isfield(thistrial,'lastpoint')
                if isfield(thistrial,'oldDots')
                    if ~isnan(lastpositionVisual(p,1)) && ~isnan(thistrial.lastpoint(p,1))
                        thistrial.oldDots{p} = [thistrial.oldDots{p} thistrial.lastpoint(p,:)' lastpositionVisual(p,:)'];
                        Screen('DrawLines', experimentdata.screenInfo.curWindow, thistrial.oldDots{p}, m.showPositionSize(p), color(therow,:), []);
                    end
                else
                    Screen('DrawLines', experimentdata.screenInfo.curWindow, [thistrial.lastpoint(p,:)' lastpositionVisual(p,:)'], m.showPositionSize(p), color(therow,:), []);
                end
            end
            % Need to draw a dot as well, because otherwise there will be no feedback if not moving
            Screen('DrawDots', experimentdata.screenInfo.curWindow, lastpositionVisual(p,:), m.showPositionSize(p), color(therow,:),[],1);
            thistrial.lastpoint(p,:) = lastpositionVisual(p,:);
        end
    elseif strcmp(m.showPositionType,'ellipse')
        % left top right bottom (4xN matrix)
        rect = [lastpositionVisual(p,1) - m.showPositionSize(p,1)/2;
            lastpositionVisual(p,2) - m.showPositionSize(p,2)/2;
            lastpositionVisual(p,1) + m.showPositionSize(p,1)/2;
            lastpositionVisual(p,2) + m.showPositionSize(p,2)/2];
        Screen('FillOval', experimentdata.screenInfo.curWindow, color(therow,:), rect);
    elseif strcmp(m.showPositionType,'rectangle')
        left = 0.55 * experimentdata.screenInfo.screenRect(3);
        top = lastpositionVisual(p,2);
        height = 0.9 * experimentdata.screenInfo.screenRect(4) - top;
        if height<0
            height = 0;
        end
        width = 0.15 * experimentdata.screenInfo.screenRect(3);
        rect = [left top left+width top+height];
        Screen('FillRect', experimentdata.screenInfo.curWindow, color(therow,:), rect);
    elseif strcmp(m.showPositionType,'image')
        imageNum = thisShowPositionColor(1);
        %fprintf('Image size: ')
        thissize = size(experimentdata.images{imageNum}); % (rows,cols)
        % left top right bottom
        imagerectangle(1,1) = lastpositionVisual(1) - ceil(thissize(2)/2);
        imagerectangle(1,2) = lastpositionVisual(2) - floor(thissize(1)/2);
        imagerectangle(1,3) = imagerectangle(1,1) + thissize(2) - 1;
        imagerectangle(1,4) = imagerectangle(1,2) + thissize(1) - 1;
        Screen('DrawTexture',experimentdata.screenInfo.curWindow,experimentdata.textures(imageNum),[],imagerectangle);
    % Run a function which will provide the feedback
    elseif m.showPositionType(1)=='@'
        eval(['thistrial = ' m.showPositionType(2:end) '(experimentdata,thistrial,lastpositionVisual,e,frame);']);
    else
        error(['Unknown showPositionType: ' m.showPositionType]);
    end
end

