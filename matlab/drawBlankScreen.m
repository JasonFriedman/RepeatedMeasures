% DRAWBLANKSCREEN - draw a blank screen in psychtoolbox

function drawBlankScreen(screenInfo)

% Draw a blank screen
Screen('DrawingFinished',screenInfo.curWindow, 0);
Screen('Flip', screenInfo.curWindow, 0, screenInfo.dontclear);
