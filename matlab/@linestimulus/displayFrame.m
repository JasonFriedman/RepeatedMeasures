% DISPLAYFRAME - present a frame of lines
% Do not call directly, will be called by runexperiment

function [thistrial,experimentdata,breakfromloop,s] = displayFrame(s,e,frame,thistrial,experimentdata)

screenInfo = experimentdata.screenInfo;
% Show each frame N times (i.e. 4 = 15 Hz with a 60 Hz monitor)
thistrial.lineframenum(frame) = ceil(frame/s.framesPerLine);
if thistrial.lineframenum(frame)>size(thistrial.lineArray,1)
    thisframe = thistrial.lineArray(end,:)';
    warning('Ran out of frames for line stimulus, reusing the last frame. Either the program is running slow or not enough lines were provided!!!!!');
else
    thisframe = thistrial.lineArray(thistrial.lineframenum(frame),:)';
end
thisx = thisframe(1);
thisy = thisframe(2);
thisangle = thisframe(3);
thisradius1 = thisframe(4);
thisradius2 = thisframe(5);
thickness = thisframe(6);

xstart = (thisx + cos(thisangle)*thisradius1) * experimentdata.screenInfo.screenRect(3);
ystart = (thisy + sin(thisangle)*thisradius1) * experimentdata.screenInfo.screenRect(4);
xend = (thisx + cos(thisangle)*thisradius2) * experimentdata.screenInfo.screenRect(3);
yend = (thisy + sin(thisangle)*thisradius2) * experimentdata.screenInfo.screenRect(4);

Screen('DrawLine', experimentdata.screenInfo.curWindow, s.color, xstart,ystart,xend,yend,thickness);

% If recording screen shots (for testing), record every 4th
if experimentdata.recordingStimuli && mod(frame,4)==0
    %GetImage call. Alter the rect argument to change the location of the screen shot
    thistrial.imageArray = [thistrial.imageArray; {Screen('GetImage', screenInfo.curWindow)}];
end

breakfromloop = 0;
