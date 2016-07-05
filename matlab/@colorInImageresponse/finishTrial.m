% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition,frame)

toFinish = 0;

lastposition = round(thistrial.lastpositionVisual);

if ~isempty(thistrial.showPositionFeedback)
    for k=1:size(thistrial.showPositionFeedback)
        if isnan(thistrial.showPositionFeedback(k,3)) && frame >= thistrial.showPositionFeedback(k,2)
            thistrial.showPositionFeedback(k,3:4) = lastpositionVisual;
        end
    end
end

imageNum = r.imageNum;

% Rect is left,top,right,bottom
pixelColor=squeeze(double(Screen('GetImage',experimentdata.textures(imageNum), [lastposition(1) lastposition(2) lastposition(1)+1 lastposition(2)+1],[], 0, 3)))';

if sum(abs(pixelColor - r.color)) <= r.distance
    if r.endtime==0
        thistrial.pressedLocation = 1;
        thistrial.pressedTime = GetSecs;
        toFinish = 1;
    else
        if isnan(thistrial.pressedTime)
            thistrial.pressedTime = GetSecs;
            thistrial.pressedLocation = 1;
            waiting=1;
        elseif GetSecs - thistrial.pressedTime >= r.endtime
            toFinish = 1;
        elseif GetSecs - thistrial.pressedTime < r.endtime
            waiting = 1;
        end
    end
else
    thistrial.pressedLocation = NaN;
    thistrial.pressedTime = NaN;
end

[keyIsDown, secs, keycode] = KbCheck(-1);
if ~isempty(find(keycode,1)) && (find(keycode,1)==KbName('q') || find(keycode,1)==KbName('n'))
    toFinish = true;
end

