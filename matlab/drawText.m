% DRAWTEXT - draw text using the psychtoolbox, centered on the screen

function textsize = drawText(thistrial,screenInfo,font,fontsize,fontstyle,thetext,noflip,textsize)

Screen('TextFont',screenInfo.curWindow, font);
Screen('TextSize',screenInfo.curWindow, fontsize);
Screen('TextStyle', screenInfo.curWindow, fontstyle);

if nargin<8 || isempty(textsize)
    textsize =Screen('TextBounds', screenInfo.curWindow,thetext);
end

% draw the text in the center
textwidth =Screen('DrawText', screenInfo.curWindow,...
    thetext,screenInfo.center(1)-textsize(3)/2, ...
    screenInfo.center(2)-textsize(4)/2,[255 255 255]);
if nargin<7 || isempty(noflip) || noflip==0
    Screen('Flip',screenInfo.curWindow,1);
    % If the background is not white, then draw it
    if ~all(thistrial.backgroundColor==0)
        Screen(screenInfo.curWindow,'FillRect',thistrial.backgroundColor);
    end
    
end

