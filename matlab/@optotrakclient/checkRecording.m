% CHECKRECORDING - check recording on this device (whether the data was OK)
% For the optotrak, it will print an error message on the screen if there is a
% problem (e.g. missing markers)

function checkRecording(s,e,dataSummary,experimentdata,thistrial)

if isstruct(dataSummary) && isfield(dataSummary,'nancount') && dataSummary.nancount > 0.3
    writetolog(e,sprintf('Did not see enough opto data, nancount = %f',dataSummary.nancount));
    thistrial.responseText = experimentdata.texts.DID_NOT_SEE_FINGER_ENOUGH;
    if thistrial.textFeedbackShowBackground
        DrawBackground(experimentdata.screenInfo,thistrial,experimentdata.boxes,experimentdata.labels,0);
    end
    drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,thistrial.responseText);
    writetolog(e,sprintf('Wrote text %s',thistrial.responseText));
    WaitSecs(2);
    if thistrial.textFeedbackShowBackground
        DrawBackground(experimentdata.screenInfo,thistrial,experimentdata.boxes,experimentdata.labels,1);
    end
end
