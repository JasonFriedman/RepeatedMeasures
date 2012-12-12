% DISPLAYFRAME - present a frame of symbols
% Do not call directly, will be called by runexperiment

function [thistrial,experimentdata,breakfromloop,s] = displayFrame(s,e,frame,thistrial,experimentdata)

thetext = thistrial.stimuli_to_present{frame};
if ~isempty(thetext)
    drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,thetext,1);
end
breakfromloop = 0;
