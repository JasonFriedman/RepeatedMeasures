% PRESTART - show the text before the trial starts

function preStart(s,experimentdata,thistrial,firsttime)

if s.showBeforeStart
    if ~isempty(experimentdata.vr) && experimentdata.vr.stereomode>0
        for k=0:1
            Screen('SelectStereoDrawBuffer', experimentdata.screenInfo.curWindow, k);
            drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,s.text,1);
        end
    else
        drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,s.text,1);
    end
end