% DISPLAYFRAME - present a frame of the text array stimulus
% Do not call directly, will be called by runexperiment

function [thistrial,experimentdata,breakfromloop,s] = displayFrame(s,e,frame,thistrial,experimentdata)

Screen('TextFont', experimentdata.screenInfo.curWindow, 'Courier New');
Screen('TextSize', experimentdata.screenInfo.curWindow, thistrial.textArrayFontSize);
Screen('TextStyle', experimentdata.screenInfo.curWindow, 0);

DrawFormattedText(experimentdata.screenInfo.curWindow, thistrial.textArraytext,s.x,s.y,s.color);
% If recording screen shots (for testing), record every 4th frame
if experimentdata.recordingStimuli && mod(frame,4)==0
    %GetImage call. Alter the rect argument to change the location of the screen shot
    thistrial.imageArray = [thistrial.imageArray; {Screen('GetImage', experimentdata.screenInfo.curWindow)}];
end

breakfromloop = 0;
