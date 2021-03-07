% DISPLAYFRAME - present a frame of a stimulus
% Do not call directly, will be called by runexperiment
% In general, the subclass should override this with an appropriate method for presenting a frame

function [thistrial,experimentdata,breakfromloop,s] = displayFrame(s,e,frame,thistrial,experimentdata)

breakfromloop = 0;

if frame<=1 || ~thistrial.dontclear
    Screen('DrawTexture',experimentdata.screenInfo.curWindow,thistrial.textureIndex);
end
