% SHOWPOSITIONCOMMON - show the position for various devices (including mouse + tablet)
% If showPosition (set per trial) =1 -> show the actual position of the device
%                                 =2 -> if using image stimuli, only show position if in state 1
%                                 =3 -> calculate position based on displayRangeX / displayRangeY / offsetX / offsetY
%                                 =4 -> same as 3, but only before the trial starts
%                                 =5 -> same as 3, but if using image stimuli, only show position if in state 1
%
% Note that lastpositionVisual is the position on the screen (not in device coordinates)

function thistrial = showPositionCommon(m,lastpositionVisual,thistrial,experimentdata,e)

thisShowPositionColor = m.showPositionColor;

% lastpositionVisual should be of size num dots * num samples * 2 (xy)

for p=1:size(lastpositionVisual,1) % number of dots
    color = thisShowPositionColor(1,(p-1)*3+(1:3));
    
    if strcmp(m.showPositionType,'dot')
        if any(thistrial.showPosition==[1 3]) || ...
                (any(thistrial.showPosition==[2 5]) && isa(thistrial.thisstimulus,'imagesstimulus') && thistrial.imageState == 1) || ...
                (thistrial.showPosition==4 && frame<1)
            dots = squeeze(lastpositionVisual(p,:,:))';
            Screen('DrawDots', experimentdata.screenInfo.curWindow, dots, m.showPositionSize(p), color,[],1);
        end
    elseif strcmp(m.showPositionType,'ellipse')
        for z=1:size(lastPositionVisual,2)
            % left top right bottom (4xN matrix)
            rect = [lastpositionVisual(p,z,z,1) - m.showPositionSize(p,z,1)/2;
                lastpositionVisual(p,z,2) - m.showPositionSize(p,z,2)/2;
                lastpositionVisual(p,z,1) + m.showPositionSize(p,z,1)/2;
                lastpositionVisual(p,z,2) + m.showPositionSize(p,z,2)/2];
            Screen('FillOval', experimentdata.screenInfo.curWindow, color, rect);
        end
    elseif strcmp(m.showPositionType,'rectangle')
        for z=1:size(lastPositionVisual,2)
            left = 0.55 * experimentdata.screenInfo.screenRect(3);
            top = lastpositionVisual(p,z,2);
            height = 0.9 * experimentdata.screenInfo.screenRect(4) - top;
            if height<0
                height = 0;
            end
            width = 0.15 * experimentdata.screenInfo.screenRect(3);
            rect = [left top left+width top+height];
            Screen('FillRect', experimentdata.screenInfo.curWindow, color, rect);
        end
    elseif strcmp(m.showPositionType,'image')
        for z=1:size(lastPositionVisual,2)
            imageNum = thisShowPositionColor(z);
            thissize = size(experimentdata.images{imageNum});
            % left top right bottom
            imagerectangle(1,1) = lastpositionVisual(p,z,1) - ceil(thissize(1)/2);
            imagerectangle(1,2) = lastpositionVisual(p,z,2) - floor(thissize(2)/2);
            imagerectangle(1,3) = imagerectangle(1,1) + thissize(1) - 1;
            imagerectangle(1,4) = imagerectangle(1,2) + thissize(2) - 1;
            Screen('DrawTexture',experimentdata.screenInfo.curWindow,experimentdata.textures(imageNum),[],imagerectangle);
        end
        % Run a function which will provide the feedback
    elseif m.showPositionType(1)=='@'
        eval(['thistrial = ' m.showPositionType(2:end) '(experimentdata,thistrial,lastpositionVisual,e,frame);']);
    else
        error(['Unknown showPositionType: ' m.showPositionType]);
    end
end

