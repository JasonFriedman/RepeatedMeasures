% CALCULATELASTPOSITION - calculate the last position, based on the recorded position and viewing parameters

function [lastsample,thistrial] = calculateLastPosition(m,lastsample,thistrial,frame)

displayRangeX = m.displayRangeX{min([numel(m.displayRangeX) thistrial.trialnum])};
displayRangeY = m.displayRangeY{min([numel(m.displayRangeY) thistrial.trialnum])};
showPositionRotationAngle = m.showPositionRotationAngle{min([numel(m.showPositionRotationAngle) thistrial.trialnum])};
showPositionRotationCenter = m.showPositionRotationCenter{min([numel(m.showPositionRotationCenter) thistrial.trialnum])};
startRotationFrame = m.startRotationFrame(min([numel(m.startRotationFrame) thistrial.trialnum]));

if thistrial.showPosition==3
    sensors = size(displayRangeX,1);
    dims = size(lastsample,2)/sensors;
    numpositions = size(displayRangeX,2) / (2*dims+1);

    for p=1:numpositions
        if size(m.offsetX,1)==1
            lastposition(p,1) = m.offsetX(1,p);
        else
            lastposition(p,1) = m.offsetX(thistrial.trialnum,p);
        end
        if size(m.offsetY,1)==1
            lastposition(p,2) = m.offsetY(1,p);
        else
            lastposition(p,2) = m.offsetY(thistrial.trialnum,p);
        end
        offset = (p-1)*(2*dims+1);
        
        for k=1:sensors
            for n=1:dims
                if numel(displayRangeX)>0 && displayRangeX(k,offset+n*2) ~= displayRangeX(k,offset+n*2-1)
                    lastposition(p,1) = lastposition(p,1) + (lastsample((k-1)*dims+n) - displayRangeX(k,offset+n*2-1)) / (displayRangeX(k,offset+n*2) - displayRangeX(k,offset+n*2-1));
                end
                if numel(displayRangeY)>0 && displayRangeY(k,offset+n*2) ~= displayRangeY(k,offset+n*2-1)
                    lastposition(p,2) = lastposition(p,2) + (lastsample((k-1)*dims+n) - displayRangeY(k,offset+n*2-1)) / (displayRangeY(k,offset+n*2) - displayRangeY(k,offset+n*2-1));
                end
            end
            if numel(displayRangeX)>0 && displayRangeX(k,offset+2*dims+1) ~= 0
                if isfield(thistrial,'StimulusOnsetTime')
                    lastposition(p,1) = lastposition(p,1) + displayRangeX(k,offset+2*dims+1) * (GetSecs - thistrial.StimulusOnsetTime(1));
                end
            end
            if numel(displayRangeY)>0 && displayRangeY(k,offset+2*dims+1) ~= 0
                if isfield(thistrial,'StimulusOnsetTime')
                    lastposition(p,2) = lastposition(p,2) + displayRangeY(k,offset+2*dims+1) * (GetSecs - thistrial.StimulusOnsetTime(1));
                end
            end
        end
        
    end
    lastsample = lastposition;
end

if ~isnan(showPositionRotationAngle(1)) && any(showPositionRotationAngle~=0) && frame >=startRotationFrame 
    for p=1:size(lastsample,1)
        rotatedposition(p,1) = (lastsample(p,1) - showPositionRotationCenter(p,1)) * cos(showPositionRotationAngle(p)) - (lastsample(p,2) - showPositionRotationCenter(p,2)) * sin(showPositionRotationAngle(p)) + showPositionRotationCenter(p,1);
        rotatedposition(p,2) = (lastsample(p,1) - showPositionRotationCenter(p,1)) * sin(showPositionRotationAngle(p)) + (lastsample(p,2) - showPositionRotationCenter(p,2)) * cos(showPositionRotationAngle(p)) + showPositionRotationCenter(p,2);
        lastsample(p,1:2) = rotatedposition(p,1:2);
    end
    thistrial.rotatedposition = rotatedposition;
end