% DRAWBOXES - draw boxes (usually for pointing to)

function DrawBoxes(boxes,screenInfo)
% Draw the boxes (in white)
for boxNum = 1:size(boxes,1)
    Screen('FrameRect',screenInfo.curWindow,[255 255 255],boxes(boxNum,:),1);
end
