% DISPLAYFRAME - present a frame of a stimulus
% Do not call directly, will be called by runexperiment
% In general, the subclass should override this with an appropriate method for presenting a frame

function [thistrial,experimentdata,breakfromloop,s] = displayFrame(s,e,frame,thistrial,experimentdata)

breakfromloop = 0;

if experimentdata.recordingStimuli
    %GetImage call. Alter the rect argument to change the location of the screen shot
    thistrial.imageArray = [thistrial.imageArray; {Screen('GetImage', experimentdata.screenInfo.curWindow)}];
end

