% CALCULATELASTPOSITION - calculate the last position, based on the recorded position and viewing parameters

function [lastsample,thistrial] = calculateLastPosition(m,lastsample,thistrial)

displayRangeX = m.displayRangeX{min([numel(m.displayRangeX) thistrial.trialnum])};
displayRangeY = m.displayRangeY{min([numel(m.displayRangeY) thistrial.trialnum])};
showPositionRotationAngle = m.showPositionRotationAngle(min([numel(m.showPositionRotationAngle) thistrial.trialnum]));
showPositionRotationCenter = m.showPositionRotationCenter{min([numel(m.showPositionRotationCenter) thistrial.trialnum])};

if thistrial.showPosition==3
    k=1; % only need one row (because only one mouse)
    if numel(m.offsetX)==1
        lastposition(1) = m.offsetX;
    else
        lastposition(1) = m.offsetX(thistrial.trialnum);
    end
    if numel(m.offsetY)==1
        lastposition(2) = m.offsetY;
    else
        lastposition(2) = m.offsetY(thistrial.trialnum);
    end
    for n=1:2
        if numel(displayRangeX)>0 && displayRangeX(k,n*2) ~= displayRangeX(k,n*2-1)
            lastposition(1) = lastposition(1) + (lastsample(n) - displayRangeX(k,n*2-1)) / (displayRangeX(k,n*2) - displayRangeX(k,n*2-1));
        end
        if numel(displayRangeY)>0 && displayRangeY(k,n*2) ~= displayRangeY(k,n*2-1)
            lastposition(2) = lastposition(2) + (lastsample(n) - displayRangeY(k,n*2-1)) / (displayRangeY(k,n*2) - displayRangeY(k,n*2-1));
        end
    end
    if numel(displayRangeX)>0 && displayRangeX(k,5) ~= 0
        if isfield(thistrial,'StimulusOnsetTime')
            lastposition(1) = lastposition(1) + displayRangeX(k,5) * (GetSecs - thistrial.StimulusOnsetTime(1));
        end
    end
    if numel(displayRangeY)>0 && displayRangeY(k,5) ~= 0
        if isfield(thistrial,'StimulusOnsetTime')
            lastposition(2) = lastposition(2) + displayRangeY(k,5) * (GetSecs - thistrial.StimulusOnsetTime(1));
        end
    end
    lastsample(1) = lastposition(1);
    lastsample(2) = lastposition(2);
end

if ~isnan(showPositionRotationAngle) && showPositionRotationAngle~=0
    rotatedposition(1) = (lastsample(1) - showPositionRotationCenter(1)) * cos(showPositionRotationAngle) - (lastsample(2) - showPositionRotationCenter(2)) * sin(showPositionRotationAngle) + showPositionRotationCenter(1);
    rotatedposition(2) = (lastsample(1) - showPositionRotationCenter(1)) * sin(showPositionRotationAngle) + (lastsample(2) - showPositionRotationCenter(2)) * cos(showPositionRotationAngle) + showPositionRotationCenter(2);
    lastsample(1:2) = rotatedposition;
    thistrial.rotatedposition = rotatedposition;
end
