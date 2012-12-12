% DISPLAYFRAME - present a frame of a stimulus
% For the VR stimulus, the hand is draw in showPosition
% (part of the glovefastrakclient class).
% This function will draw anything else (e.g. the targets),
% and when in calibrate mode, it samples the keyboard
% and updates the "calibration" (initial offset)

function [thistrial,experimentdata,breakfromloop,s] = displayFrame(s,e,frame,thistrial,experimentdata)
codes = messagecodes;

% Draw the background color
Screen('BeginOpenGL', experimentdata.screenInfo.curWindow );
glClearColor(thistrial.backgroundColor(1)/255,thistrial.backgroundColor(2)/255,thistrial.backgroundColor(3)/255,0.0);
glClear();
Screen('EndOpenGL', experimentdata.screenInfo.curWindow );

breakfromloop = 0;
% check whether the target should be on
if experimentdata.vr.stereomode>0
    stereo=1;
else
    stereo=0;
end
for m=0:stereo
    if experimentdata.vr.stereomode
        Screen('SelectStereoDrawBuffer', experimentdata.screenInfo.curWindow, m);
        setupViewingTransform(s,experimentdata,m+1); % Includes Screen('BeginOpenGL')
    else
        Screen('BeginOpenGL', experimentdata.screenInfo.curWindow);
    end
    for k=1:numel(s.target)
        if (frame > 1) && ~isempty(s.target{k}.onTime) && ~isempty(s.target{k}.offTime) && ...
                (thistrial.frameInfo.startFrame(frame) - thistrial.frameInfo.startFrame(1) >= s.target{k}.onTime) && ...
                (thistrial.frameInfo.startFrame(frame) - thistrial.frameInfo.startFrame(1) < s.target{k}.offTime)
            if ~isfield(s.target{k},'marked')
                % Mark the event with codes.targetOn (=1000) + the target number
                markEvent(e,codes.targetOn+k);
                s.target{k}.marked = 1;
            end
            %draw the target(s)
            render_target(s,k);
        end
    end
    Screen('EndOpenGL', experimentdata.screenInfo.curWindow);
end
% If this is a calibration trial, check if a relevant key has been pressed
if ~isempty(s.calibrate)
    [keycode, keycode,keycode] = KbCheck;
    if ~isempty(find(keycode, 1))
        thistranslation = s.calibrate.translatedelta;
        thisscale = s.calibrate.scaledelta;
        thisrotate = s.calibrate.rotatedelta;
        
        switch(KbName(find(keycode,1)))
            case 'LeftArrow'
                if  s.showFlipped
                    experimentdata.vr.translation = experimentdata.vr.translation - [thistranslation 0 0];
                else
                    experimentdata.vr.translation = experimentdata.vr.translation + [thistranslation 0 0];
                end
            case 'RightArrow'
                if  s.showFlipped
                    experimentdata.vr.translation = experimentdata.vr.translation + [thistranslation 0 0];
                else
                    experimentdata.vr.translation = experimentdata.vr.translation - [thistranslation 0 0];
                end
            case 'UpArrow'
                experimentdata.vr.translation = experimentdata.vr.translation + [0 thistranslation 0];
            case 'DownArrow'
                experimentdata.vr.translation = experimentdata.vr.translation - [0 thistranslation 0];
            case 'PageUp'
                experimentdata.vr.translation = experimentdata.vr.translation + [0 0 thistranslation];
            case 'PageDown'
                experimentdata.vr.translation = experimentdata.vr.translation - [0 0 thistranslation];
            case '4'
                experimentdata.vr.cameralocation(1) = experimentdata.vr.cameralocation(1) - thistranslation;
                setupViewingTransform(s,experimentdata,0);
            case '6'
                experimentdata.vr.cameralocation(1) = experimentdata.vr.cameralocation(1) + thistranslation;
                setupViewingTransform(s,experimentdata,0);
            case '2'
                experimentdata.vr.cameralocation(2) = experimentdata.vr.cameralocation(2) - thistranslation;
                setupViewingTransform(s,experimentdata,0);
            case '8'
                experimentdata.vr.cameralocation(2) = experimentdata.vr.cameralocation(2) + thistranslation;
                setupViewingTransform(s,experimentdata,0);
            case '7'
                experimentdata.vr.cameralocation(3) = experimentdata.vr.cameralocation(3) - thistranslation;
                setupViewingTransform(s,experimentdata,0);
            case '9'
                experimentdata.vr.cameralocation(3) = experimentdata.vr.cameralocation(3) + thistranslation;
                setupViewingTransform(s,experimentdata,0);
            case 'r'
                experimentdata.vr.rotate = experimentdata.vr.rotate + thisrotate;
            case 's'
                experimentdata.vr.rotate = experimentdata.vr.rotate - thisrotate;
            case 'x'
                experimentdata.vr.scale(1) = experimentdata.vr.scale(1) + thisscale;
            case 'c'
                experimentdata.vr.scale(1) = experimentdata.vr.scale(1) - thisscale;
            case 'y'
                experimentdata.vr.scale(2) = experimentdata.vr.scale(2) + thisscale;
            case 'z'
                experimentdata.vr.scale(3) = experimentdata.vr.scale(3) + thisscale;
            case 'space'
                breakfromloop = 1;
            case 'q'
                breakfromloop = 1;
        end
    end
else
    [keycode, keycode,keycode] = KbCheck;
    if keycode(KbName('q'))==1
        breakfromloop = 1;
    end
end
