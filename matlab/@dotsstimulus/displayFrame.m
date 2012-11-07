% DISPLAYFRAME - present a frame of dots
% Do not call directly, will be called by runexperiment

function [thistrial,experimentdata,breakfromloop,s] = displayFrame(s,e,frame,thistrial,experimentdata)

screenInfo = experimentdata.screenInfo;
% Show each frame N times (i.e. 4 = 15 Hz with a 60 Hz monitor)
thisdot = thistrial.dotArray(ceil(frame/s.framesPerDot),:)';
Screen('DrawDots', screenInfo.curWindow, thisdot, 10 , 255,[],1);
Screen('DrawingFinished',screenInfo.curWindow,screenInfo.dontclear);
Screen('BlendFunction', screenInfo.curWindow, GL_ONE, GL_ZERO);
% If recording screen shots (for testing), record every 4th
if experimentdata.recordingStimuli && mod(frame,4)==0
    %GetImage call. Alter the rect argument to change the location of the screen shot
    thistrial.imageArray = [thistrial.imageArray; {Screen('GetImage', screenInfo.curWindow)}];
end

breakfromloop = 0;
