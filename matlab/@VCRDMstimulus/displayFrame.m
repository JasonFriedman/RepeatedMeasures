% DISPLAYFRAME - present a frame of VCRDM
% Do not call directly, will be called by runexperiment

function [thistrial,experimentdata,breakfromloop,s] = displayFrame(s,e,frame,thistrial,experimentdata)
    
    breakfromloop = 0;
    if frame<s.firstframe
        return;
    end
    thistrial.dotInfo = draw_prepared_dots_frame(experimentdata.screenInfo,thistrial.dotInfo,frame-s.firstframe+1,thistrial);
    
   if experimentdata.recordingStimuli
        %GetImage call. Alter the rect argument to change the location of the screen shot
        thistrial.imageArray = [thistrial.imageArray; {Screen('GetImage', experimentdata.screenInfo.curWindow)}];
   end

