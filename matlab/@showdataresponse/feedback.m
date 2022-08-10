% FEEDBACK - Provide feedback - show the data

function thistrial = feedback(r,e,thistrial,previoustrial,experimentdata,dataSummary,results)

    % Draw the background
    Screen(experimentdata.screenInfo.curWindow,'FillRect',thistrial.backgroundColor);

    if ~isempty(r.backgroundImage)
        Screen('DrawTexture',experimentdata.screenInfo.curWindow,experimentdata.textures(r.backgroundImage));
    end

    lastsampleVisual = calculateLastPosition(r,dataSummary,thistrial);    
    lastpositionVisual(:,:,1) = lastsampleVisual(:,:,1) * experimentdata.screenInfo.screenRect(3);
    lastpositionVisual(:,:,2) = lastsampleVisual(:,:,2) * experimentdata.screenInfo.screenRect(4);
    
    thistrial = showPositionCommon(r,lastpositionVisual,thistrial,experimentdata,e);
    Screen('Flip',experimentdata.screenInfo.curWindow,1);
    WaitSecs(r.waitTime);
end