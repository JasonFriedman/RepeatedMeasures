% DISPLAYFRAME - present a frame of dots
% Do not call directly, will be called by runexperiment

function [thistrial,experimentdata,breakfromloop,s] = displayFrame(s,e,frame,thistrial,experimentdata)

screenInfo = experimentdata.screenInfo;
% Show each frame N times (i.e. 4 = 15 Hz with a 60 Hz monitor)
thisdot = thistrial.dotArray(min([size(thistrial.dotArray,1) ceil(frame/s.framesPerDot)]),:)';
if s.type<=2
    Screen('DrawDots', screenInfo.curWindow, thisdot, s.size , s.color,[],s.type);
elseif s.type==3
    % left top right bottom (4xN matrix)
    rect = [thisdot(1,:) - s.size(1)/2;
        thisdot(2,:) - s.size(2)/2;
        thisdot(1,:) + s.size(1)/2;
        thisdot(2,:) + s.size(2)/2];
    Screen('FillOval', screenInfo.curWindow, s.color, rect);
else
    error('Unknown dot type %d',s.type);
end
%Screen('DrawingFinished',screenInfo.curWindow,thistrial.dontclear);
%Screen('BlendFunction', screenInfo.curWindow, GL_ONE, GL_ZERO);
% If recording screen shots (for testing), record every 4th
if experimentdata.recordingStimuli && mod(frame,4)==0
    %GetImage call. Alter the rect argument to change the location of the screen shot
    thistrial.imageArray = [thistrial.imageArray; {Screen('GetImage', screenInfo.curWindow)}];
end

breakfromloop = 0;
