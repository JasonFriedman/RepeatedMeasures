% DRAWTEXTLOCATION - draw text using the psychtoolbox, at the specified location
% drawTextLocation(screenInfo,font,fontsize,fontstyle,thetext,location,noflip)

function drawTextLocation(screenInfo,font,fontsize,fontstyle,thetext,location,noflip)

Screen('TextFont',screenInfo.curWindow, font);
Screen('TextSize',screenInfo.curWindow, fontsize);
Screen('TextStyle', screenInfo.curWindow, fontstyle);
textsize =Screen('TextBounds', screenInfo.curWindow,thetext);
% draw the text in the center
textwidth =Screen('DrawText', screenInfo.curWindow,...
    thetext,location(1)-textsize(3)/2, ...
    location(2)-textsize(4)/2,[255 255 255]);
if nargin<7 || isempty(noflip) || noflip==0
    Screen('Flip',screenInfo.curWindow,1);
end

