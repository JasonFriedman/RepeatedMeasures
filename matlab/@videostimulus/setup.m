% SETUP - Prepare a "video" trial
% Do not call directly, will be called by runexperiment

function thistrial = setup(s,e,thistrial,experimentdata)

videoFilename = [pwd '/stimuli/' s.filename];
% The -1 signifies to put the whole movie into RAM, without
% this it did not seem to be always loading the whole
% video.
try
   Screen('CloseMovie'); % close any open movies 
   [ thistrial.moviePtr, duration, thistrial.video_fps, width, height, thistrial.video_frames] = ...
       Screen('OpenMovie', experimentdata.screenInfo.curWindow, videoFilename, 0 , -1);
catch
    fprintf('Caught error trying to open movie, trying again\n');
    pause(1);
    [ thistrial.moviePtr, duration, thistrial.video_fps, width, height, thistrial.video_frames] = ...
       Screen('OpenMovie', experimentdata.screenInfo.curWindow, videoFilename, 0 , -1);
end

if thistrial.moviePtr==-1
    error(['Could not load file ' videoFilename]);
end
Screen('SetMovieTimeIndex', thistrial.moviePtr, 0);
thistrial.stimuliFrames = thistrial.video_frames+1; % extra frame to close the video and release the memory
fprintf('There are %d frames in the video\n',thistrial.stimuliFrames-1);


