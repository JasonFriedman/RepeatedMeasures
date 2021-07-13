% DRAWTEXT - draw text using the psychtoolbox, centered on the screen
%
% textsize = drawText(thistrial,screenInfo,font,fontsize,fontstyle,thetext,noflip,textsize)


function textsize = drawText(thistrial,screenInfo,font,fontsize,fontstyle,thetext,noflip,textsize,textColor,swapDirection)

if nargin<9 || isempty(textColor)
    textColor = [255 255 255];
end

if nargin<10 || isempty(swapDirection)
    swapDirection = 0;
end

Screen('TextFont',screenInfo.curWindow, font);
Screen('TextSize',screenInfo.curWindow, fontsize);
Screen('TextStyle', screenInfo.curWindow, fontstyle);

if nargin<8 || isempty(textsize)
    textsize =Screen('TextBounds', screenInfo.curWindow,thetext);
end

if swapDirection
    Screen('glPushMatrix', screenInfo.curWindow);
    % Translate origin into the geometric center of text:
    [xc, yc] = RectCenter(textsize);
    Screen('glTranslate', screenInfo.curWindow, xc, yc, 0);
    Screen('glScale', screenInfo.curWindow, -1, 1, 1);
    % We need to undo the translations...
    Screen('glTranslate', screenInfo.curWindow, -xc, -yc, 0);
end

% draw the text in the center
textwidth =Screen('DrawText', screenInfo.curWindow,...
    thetext,screenInfo.center(1)-textsize(3)/2, ...
    screenInfo.center(2)-textsize(4)/2,textColor,[],[],swapDirection);

if swapDirection
    Screen('glPopMatrix', screenInfo.curWindow);
end

if nargin<7 || isempty(noflip) || noflip==0
    Screen('Flip',screenInfo.curWindow,1);
    % If the background is not white, then draw it
    if ~all(thistrial.backgroundColor==0)
        Screen(screenInfo.curWindow,'FillRect',thistrial.backgroundColor);
    end
    
end

