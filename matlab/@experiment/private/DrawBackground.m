% DRAWBACKGROUND - draw the background (made up of what is in boxes and labels)

function DrawBackground(experimentdata,thistrial,boxes,labels,toflip)

screenInfo = experimentdata.screenInfo;

if ~isnan(boxes(1)) || (~isempty(labels) && ~isempty(labels(1)))
    if ~isnan(boxes(1)) && isfield(thistrial,'boxes') && ~isempty(thistrial.boxes) && ~isnan(thistrial.boxes(1))
        DrawBoxes(boxes(thistrial.boxes,:),screenInfo);
    end
    if ~isempty(labels) && ~isempty(labels(1))
        DrawLabels(thistrial,labels(thistrial.labels),screenInfo);
    end
    if toflip
        Screen('Flip',screenInfo.curWindow,1);
        % If the background is not white, then draw it
        if ~all(thistrial.backgroundColor==0)
            Screen(screenInfo.curWindow,'FillRect',thistrial.backgroundColor);
        end
        if ~isempty(thistrial.backgroundImage)
            Screen('DrawTexture',screenInfo.curWindow,thistrial.backgroundImage);
        end
    end
else
    if toflip
        % draw blank screen
        Screen('DrawingFinished',screenInfo.curWindow, 0);
        Screen('Flip', screenInfo.curWindow, 0, thistrial.dontclear);
        % If the background is not white, then draw it
        if ~all(thistrial.backgroundColor==0)
            Screen(screenInfo.curWindow,'FillRect',thistrial.backgroundColor);
        end
        if ~isempty(thistrial.backgroundImage)
            Screen('DrawTexture',screenInfo.curWindow,experimentdata.textures(thistrial.backgroundImage));
        end
    end
end
