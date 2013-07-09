% DISPLAYFRAME - show which fingers are touching
% Do not call directly, will be called by runexperiment

function [thistrial,experimentdata,breakfromloop,s] = displayFrame(s,e,frame,thistrial,experimentdata)

screenInfo = experimentdata.screenInfo;
font = 'Courier';
fontsize = 20;
fontstyle = 0;
noflip = 1;

if s.feedbackType==1
    if isfield(thistrial,'currentlyTouching')
        thetext = ['currentlyTouching: ' num2str(thistrial.currentlyTouching)];
    else
        thetext = 'waiting';
    end
    drawText(thistrial,screenInfo,font,fontsize,fontstyle,thetext,noflip);

elseif s.feedbackType==2
    if isfield(thistrial,'currentlyTouching')
        DrawFormattedText(screenInfo.curWindow,sprintf('currentlyTouching: %d\ntouchTreshold: %.2f\nuntouchThreshold: %.2f\nfingertipdistance: %.2f',thistrial.currentlyTouching,...
            get(thistrial.thisresponse,'touchThreshold'),...
            get(thistrial.thisresponse,'untouchThreshold'),...
            get(thistrial.thisresponse,'fingertipdistance')));                      
    else
        thetext = 'waiting';
        drawText(thistrial,screenInfo,font,fontsize,fontstyle,thetext,noflip);
    end
end

breakfromloop = 0;
