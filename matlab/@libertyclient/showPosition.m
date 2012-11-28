% SHOWPOSITION - show the position for the liberty (as a dot)

function [lastposition,thistrial] = showPosition(m,thistrial,experimentdata,e,frame)
% get the current position
lastsample = getsample(m);

lastposition(1) = m.offsetX;
lastposition(2) = m.offsetY;

for k=1:m.numsensors
    
    % [2 3 4] are the x y z coordinates. Subtract the "zero" if it has been recorded
    rng = k*3-1 : k*3+1;
    if isfield(experimentdata,'targetPosition') && ~isempty(experimentdata.targetPosition)
        xyz = lastsample(rng) - experimentdata.targetPosition(1,rng-1);
    else
        xyz = lastsample(rng);
    end
    
    if (m.displayRangeX(k,2) ~= m.displayRangeX(k,1))
        lastposition(1) = lastposition(1) + (xyz(1) - m.displayRangeX(k,1)) /(m.displayRangeX(k,2) - m.displayRangeX(k,1));
    end
    if (m.displayRangeX(k,4) ~= m.displayRangeX(k,3))
        lastposition(1) = lastposition(1) + (xyz(2) - m.displayRangeX(k,3)) /(m.displayRangeX(k,4) - m.displayRangeX(k,3));
    end
    if (m.displayRangeX(k,6) ~= m.displayRangeX(k,4))
        lastposition(1) = lastposition(1) + (xyz(3) - m.displayRangeX(k,5)) /(m.displayRangeX(k,6) - m.displayRangeX(k,5));
    end
    if m.displayRangeX(k,7) ~= 0
        if isfield(thistrial,'StimulusOnsetTime')
            lastposition(1) = lastposition(1) + m.displayRangeX(k,7) * (GetSecs - thistrial.StimulusOnsetTime(1));
        end
    end
    if (m.displayRangeY(k,2) ~= m.displayRangeY(k,1))
        lastposition(2) = lastposition(2) + (xyz(1) - m.displayRangeY(k,1)) /(m.displayRangeY(k,2) - m.displayRangeY(k,1));
    end
    if (m.displayRangeY(k,4) ~= m.displayRangeY(k,3))
        lastposition(2) = lastposition(2) + (xyz(2) - m.displayRangeY(k,3)) /(m.displayRangeY(k,4) - m.displayRangeY(k,3));
    end
    if (m.displayRangeY(k,6) ~= m.displayRangeY(k,5))
        lastposition(2) = lastposition(2) + (xyz(3) - m.displayRangeY(k,5)) /(m.displayRangeY(k,6) - m.displayRangeY(k,5));
    end
    if m.displayRangeY(k,7) ~= 0
        if isfield(thistrial,'StimulusOnsetTime')
            lastposition(2) = lastposition(2) + m.displayRangeY(k,7) * (GetSecs - thistrial.StimulusOnsetTime(1));
        end
    end
end

lastposition(1) = lastposition(1) * experimentdata.screenInfo.screenRect(3);
lastposition(2) = lastposition(2) * experimentdata.screenInfo.screenRect(4);

Screen('DrawDots', experimentdata.screenInfo.curWindow, lastposition, 6, m.showPositionColor,[],1);

lastposition(3) = 0;