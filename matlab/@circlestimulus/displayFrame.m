% DISPLAYFRAME - present a frame of circles
% Do not call directly, will be called by runexperiment

function [thistrial,experimentdata,breakfromloop,s] = displayFrame(s,e,frame,thistrial,experimentdata)

screenInfo = experimentdata.screenInfo;
% Show each frame N times (i.e. 4 = 15 Hz with a 60 Hz monitor)
thisradius = thistrial.circleArray(ceil(frame/s.framesPerCircle),1)';
radius = thisradius * experimentdata.screenInfo.screenRect(3);

if size(thistrial.circleArray,2) == 1 % just radii
    thiscenter = [0.5 * experimentdata.screenInfo.screenRect(3) 0.5 * experimentdata.screenInfo.screenRect(4)];
else
    thiscenter = thistrial.circleArray(ceil(frame/s.framesPerCircle),2:3);
    thiscenter = [thiscenter(1) * experimentdata.screenInfo.screenRect(3) ...
                  thiscenter(2) * experimentdata.screenInfo.screenRect(4)];
end

if radius > 0
    circleleft = thiscenter(1) - radius;
    circleright = thiscenter(1) + radius;
    circletop = thiscenter(2) - radius;
    circlebottom = thiscenter(2) + radius;
    rect = [circleleft circletop circleright circlebottom];
    if s.filled
        Screen('FillOval', experimentdata.screenInfo.curWindow, s.color, rect);
    else
        Screen('FrameOval', experimentdata.screenInfo.curWindow, s.color, rect);
    end
end

% If recording screen shots (for testing), record every 4th
if experimentdata.recordingStimuli && mod(frame,4)==0
    %GetImage call. Alter the rect argument to change the location of the screen shot
    thistrial.imageArray = [thistrial.imageArray; {Screen('GetImage', screenInfo.curWindow)}];
end

breakfromloop = 0;
