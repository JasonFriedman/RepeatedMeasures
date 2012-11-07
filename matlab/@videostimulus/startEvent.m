% STARTEVENT - start a "video" event
% Do not call directly, will be called by runexperiment

function [thistrial,experimentdata] = startEvent(s,thistrial,experimentdata,codes)

thistrial.droppedframes = Screen('PlayMovie', thistrial.moviePtr, 1, 0, 1);
fprintf('Starting playing movie');
thistrial.videoframe=1;
thistrial.last_pts = -1;
