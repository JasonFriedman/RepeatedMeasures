% FEEDBACK - provide feedback in movement threshold trials
% This should not be run directly, it is called by runexperiment.m

function thistrial = feedback(r,e,thistrial,previoustrial,experimentdata,dataSummary,results)
if thistrial.targetNum > 0
    thresholdAxis = r.thresholdAxis;
    thresholdAmount = r.thresholdAmount;
    if thistrial.separateMarkers
        % for target position 2 (left), use first marker, for 3 (right) use second marker
        threshold = thresholdAmount * (experimentdata.targetPosition(thistrial.targetNum,thistrial.targetNum-1,:) - experimentdata.targetPosition(1,thistrial.targetNum-1,:));
        lastLocation = dataSummary.meanfinalpositions(thistrial.targetNum-1,thresholdAxis) - experimentdata.targetPosition(1,thistrial.targetNum-1,thresholdAxis);
        if thistrial.targetNum==2
            otherTargetNum = 2;
        else
            otherTargetNum = 1;
        end
        lastLocationOther = dataSummary.meanfinalpositions(otherTargetNum,thresholdAxis) - experimentdata.targetPosition(1,otherTargetNum,thresholdAxis);
        thispos = dataSummary.meanpositions(thistrial.targetNum-1,thresholdAxis) - experimentdata.targetPosition(1,thistrial.targetNum-1,thresholdAxis);
        threshold = threshold(thresholdAxis);
        % Check when they crossed 10% of the distance
        tenpercent = 0.1 * (experimentdata.targetPosition(thistrial.targetNum,thresholdAxis) - experimentdata.targetPosition(1,thistrial.targetNum-1,thresholdAxis));
    else
        threshold = thresholdAmount * (experimentdata.targetPosition(thistrial.targetNum,:) - experimentdata.targetPosition(1,:));
        lastLocation = dataSummary.meanfinalposition(thresholdAxis) - targetPosition(1,1);
        thispos = dataSummary.meanposition(:,thresholdAxis) - experimentdata.targetPosition(1,thresholdAxis);
        threshold = threshold(thresholdAxis);
        % Check when they crossed 10% of the distance
        tenpercent = 0.1 * (experimentdata.targetPosition(thistrial.targetNum,thresholdAxis) - experimentdata.targetPosition(1,thresholdAxis));
    end
    
    if tenpercent<0
        crossedtenpercenttime = find(thispos<tenpercent,1,'first') * 1000/800;
    else
        crossedtenpercenttime = find(thispos>tenpercent,1,'first') * 1000/800;
    end
else
    threshold = 0;
    thistrial.successful = -1;
    thistrial.responseText = ' ';
end
if thistrial.targetNum>0 && stimuliFrames > 0
    thistrial.questSuccess = -1;
    % Check if they moved too early (10% before movement stimulus offset)
    if crossedtenpercenttime > (triggerTime * 1000)
        thistrial.successful = -1;
        writetolog(e,'Moved too early');
        thistrial.responseText = experimentdata.texts.TOO_EARLY;
    else
        if threshold < 0
            if lastLocation < threshold
                thistrial.successful = 1;
                thistrial.questSuccess = 1;
                writetolog(e,'Succesful to left target');
                thistrial.responseText = experimentdata.texts.SUCCESS;
            elseif ~separateMarkers && lastLocation < 0
                thistrial.successful = 0;
                writetolog(e,'Not far enough to left target');
                thistrial.responseText = experimentdata.texts.NOT_FAR_ENOUGH_LEFT;
            else
                thistrial.successful = 0;
                thistrial.questSuccess = 0;
                writetolog(e,'Unsuccessful (wrong way)');
                thistrial.responseText = experimentdata.texts.WRONG;
            end
        elseif threshold > 0
            if lastLocation > threshold
                thistrial.successful = 1;
                thistrial.questSuccess = 1;
                writetolog(e,'Successful to right target');
                thistrial.responseText = experimentdata.texts.SUCCESS;
            elseif ~thistrial.separateMarkers && lastLocation > 0
                thistrial.successful = 0;
                writetolog(e,'Not far enough to right target');
                thistrial.responseText = experimentdata.texts.NOT_FAR_ENOUGH_RIGHT;
            elseif ~separateMarkers || (separateMarkers && lastLocationOther > threshold)
                thistrial.successful = 0;
                thistrial.questSuccess = 0;
                writetolog(e,'Unsuccessful (wrong way)');
                thistrial.responseText = experimentdata.texts.WRONG;
            else
                thistrial.successful = -1;
                writetolog(e,'Neither');
                thistrial.responseText = experimentdata.texts.NEITHER_TARGET;
            end
            
        else
            thistrial.responseText = ' ';
            thistrial.successful = -1;
        end
    end
end

