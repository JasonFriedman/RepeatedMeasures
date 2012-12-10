% PRESTART - show the text before the trial starts

function preStart(s,experimentdata,thistrial,firsttime)

if ~isempty(experimentdata.vr) && experimentdata.vr.stereomode>0
    for k=0:1
        Screen('SelectStereoDrawBuffer', experimentdata.screenInfo.curWindow, k);
        drawText(experimentdata.screenInfo,'Courier',100,0,s.text,1);
    end
else
    drawText(experimentdata.screenInfo,'Courier',100,0,s.text,1);
end
