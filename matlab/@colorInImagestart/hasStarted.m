% HASSTARTED - has the trial started?
% Do not call directly, will be called by runexperiment

function [started,keycode,thistrial] = hasStarted(r,e,experimentdata,thistrial)

started = 0;

lastposition = round(thistrial.lastpositionVisual);

% needs to be < and not <= because we look at the location +1
if ~isempty(lastposition) && all(lastposition>0) && ...
        lastposition(1)< experimentdata.screenInfo.screenRect(3) && ...
        lastposition(2) < experimentdata.screenInfo.screenRect(4)
    imageNum = r.imageNum;
    
    % Rect is left,top,right,bottom
    pixelColor=squeeze(double(Screen('GetImage',experimentdata.textures(imageNum), [lastposition(1) lastposition(2) lastposition(1)+1 lastposition(2)+1],[], 0, 3)))';
        
    if sum(abs(pixelColor - r.color)) <= r.distance
        if r.starttime==0
            thistrial.startpressedTime = GetSecs;
            started = 1;
        else
            if isnan(thistrial.startpressedTime)
                thistrial.startpressedTime = GetSecs;
                %waiting=1;
            elseif GetSecs - thistrial.startpressedTime >= r.starttime
                started = 1;
            elseif GetSecs - thistrial.startpressedTime < r.starttime
                %waiting = 1;
            end
        end
    else
        thistrial.startpressedTime = NaN;
    end
end

[keyIsDown, secs, keycode] = KbCheck(-1);
if ~isempty(find(keycode,1)) && (find(keycode,1)==KbName('q') || find(keycode,1)==KbName('n'))
    started = true;
end