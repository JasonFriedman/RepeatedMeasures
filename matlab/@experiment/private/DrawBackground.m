% DRAWBACKGROUND - draw the background (made up of what is in boxes and labels)

function DrawBackground(screenInfo,thistrial,boxes,labels,toflip)

if ~isnan(boxes(1)) || (~isempty(labels) && ~isempty(labels(1)))
    if ~isnan(boxes(1)) && isfield(thistrial,'boxes') && ~isempty(thistrial.boxes)
        DrawBoxes(boxes(thistrial.boxes,:),screenInfo);
    end
    if ~isempty(labels) && ~isempty(labels(1))
        DrawLabels(labels(thistrial.labels),screenInfo);
    end
    if toflip
        Screen('Flip',screenInfo.curWindow,1);
    end
else
    if toflip
        % draw blank screen
        Screen('DrawingFinished',screenInfo.curWindow, 0);
        Screen('Flip', screenInfo.curWindow, 0, thistrial.dontclear);
    end
end
