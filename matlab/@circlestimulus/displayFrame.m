% DISPLAYFRAME - present a frame of circles
% Do not call directly, will be called by runexperiment

function [thistrial,experimentdata,breakfromloop,s] = displayFrame(s,e,frame,thistrial,experimentdata)

screenInfo = experimentdata.screenInfo;
% Show each frame N times (i.e. 4 = 15 Hz with a 60 Hz monitor)
thisradius = thistrial.circleArray(ceil(frame/s.framesPerCircle),:)';
halfradius = 0.5 * thisradius * experimentdata.screenInfo.screenRect(3);

if halfradius > 0
    circleleft = 0.5 * experimentdata.screenInfo.screenRect(3) - halfradius;
    circleright = 0.5 * experimentdata.screenInfo.screenRect(3) + halfradius;
    circletop = 0.5 * experimentdata.screenInfo.screenRect(4) + halfradius;
    circlebottom = 0.5 * experimentdata.screenInfo.screenRect(4) - halfradius;
    rect = [circleleft circlebottom circleright circletop];
    Screen('FrameOval', experimentdata.screenInfo.curWindow, s.color, rect);
end

% If recording screen shots (for testing), record every 4th
if experimentdata.recordingStimuli && mod(frame,4)==0
    %GetImage call. Alter the rect argument to change the location of the screen shot
    thistrial.imageArray = [thistrial.imageArray; {Screen('GetImage', screenInfo.curWindow)}];
end

breakfromloop = 0;
