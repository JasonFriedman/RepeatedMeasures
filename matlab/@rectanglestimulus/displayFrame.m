% DISPLAYFRAME - present a frame of rectangles
% Do not call directly, will be called by runexperiment

function [thistrial,experimentdata,breakfromloop,s] = displayFrame(s,e,frame,thistrial,experimentdata)

screenInfo = experimentdata.screenInfo;
% Show each frame N times (i.e. 4 = 15 Hz with a 60 Hz monitor)
thisframe = thistrial.rectangleArray(ceil(frame/s.framesPerRectangle),:)';
thisx = thisframe(1) * experimentdata.screenInfo.screenRect(3);
thisy = thisframe(2) * experimentdata.screenInfo.screenRect(4);
thiswidth = thisframe(3) * experimentdata.screenInfo.screenRect(3);
thisheight = thisframe(4) * experimentdata.screenInfo.screenRect(4);
tofill = thisframe(5);


if thiswidth > 0 && thisheight > 0
    rect = [thisx thisy thisx+thiswidth thisy+thisheight];
    if tofill
        Screen('FillRect', experimentdata.screenInfo.curWindow, s.color, rect);
    else
        Screen('FrameRect', experimentdata.screenInfo.curWindow, s.color, rect);
    end
end

% If recording screen shots (for testing), record every 4th
if experimentdata.recordingStimuli && mod(frame,4)==0
    %GetImage call. Alter the rect argument to change the location of the screen shot
    thistrial.imageArray = [thistrial.imageArray; {Screen('GetImage', screenInfo.curWindow)}];
end

breakfromloop = 0;
