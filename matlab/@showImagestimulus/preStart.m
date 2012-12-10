% PRESTART - show the text before the trial starts

function preStart(s,experimentdata,thistrial,firsttime)

if ~isempty(experimentdata.vr) && experimentdata.vr.stereomode>0
    for k=0:1
        Screen('SelectStereoDrawBuffer', experimentdata.screenInfo.curWindow, k);
        Screen('DrawTexture',experimentdata.screenInfo.curWindow,thistrial.textureIndex);
    end
else
    Screen('DrawTexture',experimentdata.screenInfo.curWindow,thistrial.textureIndex);
end

