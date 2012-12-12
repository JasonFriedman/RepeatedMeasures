% DISPLAYFRAME - present a frame of video
% Do not call directly, will be called by runexperiment

function [thistrial,experimentdata,breakfromloop,s] = displayFrame(s,e,frame,thistrial,experimentdata)

breakfromloop = 0;
% Return next frame in movie, in sync with current playback
% time and sound.
% tex either the texture handle or zero if no new frame is
% ready yet. pts = Presentation timestamp in seconds.
[tex pts] = Screen('GetMovieImage', experimentdata.screenInfo.curWindow, thistrial.moviePtr, 1, [], [], 0);

if tex==0 % this should never be run
    % if tex==0, it is not ready to draw a new frame
    % yet, so wait until the next refresh
    Screen('WaitBlanking', windowPtr , 1);
elseif tex<0
    % it is finished
    Screen('Flip',experimentdata.screenInfo.curWindow,1);
    % If the background is not white, then draw it
    if ~all(thistrial.backgroundColor==0)
        Screen(screenInfo.curWindow,'FillRect',thistrial.backgroundColor);
    end
    breakfromloop = 1;
else
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', experimentdata.screenInfo.curWindow, tex);
    
    % Release texture:
    Screen('Close', tex);
    % is this a new frame?
    if (pts - thistrial.last_pts) > 0.01 || thistrial.videoframe==thistrial.video_frames
        thistrial.videoframe = thistrial.videoframe + 1;
    end
    thistrial.last_pts = pts;
end
