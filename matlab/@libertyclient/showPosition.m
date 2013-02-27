% SHOWPOSITION - show the position for the liberty (as a dot)

function [lastposition,thistrial] = showPosition(m,thistrial,experimentdata,e,frame)
% get the current position
lastsample = getsample(m);

lastposition(1) = m.offsetX(1);
lastposition(2) = m.offsetY(1);

for k=1:m.numsensors
    
    if thistrial.showPosition>1
        if numel(m.offsetX)>1
            lastposition(1) = m.offsetX(k);
            lastposition(2) = m.offsetY(k);
        else
            lastposition(1) = m.offsetX;
            lastposition(2) = m.offsetY;
        end
    end
    
    % [2 3 4] are the x y z coordinates. Subtract the "zero" if it has been recorded
    if m.recordOrientation
        rng = k*6-4 : k*6-2;
        rngOrientation = k*6-1:k*6+1;
        aer = degtorad(lastsample(rngOrientation));
        ca = cos(aer(1)); sa = sin(aer(1));
        ce = cos(aer(2)); se = sin(aer(2));
        cr = cos(aer(3)); sr = sin(aer(3));
        attitudeMatrix = [ca*ce, ca*se*sr - sa*cr, ca*se*cr + sa * sr;
            sa*ce, ca*cr + sa*se*sr, sa*se*cr - ca * sr;
            -se,   ce*sr,            ce*cr;];   % from p10 of the Liberty manual
    else
        rng = k*3-1 : k*3+1;
    end
    if isfield(experimentdata,'targetPosition') && ~isempty(experimentdata.targetPosition)
        xyz = lastsample(rng) - experimentdata.targetPosition(1,rng-1);
    else
        xyz = lastsample(rng);
    end
    
    for n=1:3
        if m.displayRangeX(k,n*2) ~= m.displayRangeX(k,n*2-1)
            lastposition(1) = lastposition(1) + (xyz(n) - m.displayRangeX(k,n*2-1)) / (m.displayRangeX(k,n*2) - m.displayRangeX(k,n*2-1));
        end
        if m.displayRangeY(k,n*2) ~= m.displayRangeY(k,n*2-1)
            lastposition(2) = lastposition(2) + (xyz(n) - m.displayRangeY(k,n*2-1)) / (m.displayRangeY(k,n*2) - m.displayRangeY(k,n*2-1));
        end
    end
    
    if m.displayRangeX(k,7) ~= 0
        if isfield(thistrial,'StimulusOnsetTime')
            lastposition(1) = lastposition(1) + m.displayRangeX(k,7) * (GetSecs - thistrial.StimulusOnsetTime(1));
        end
    end
    if m.displayRangeY(k,7) ~= 0
        if isfield(thistrial,'StimulusOnsetTime')
            lastposition(2) = lastposition(2) + m.displayRangeY(k,7) * (GetSecs - thistrial.StimulusOnsetTime(1));
        end
    end
    
    if thistrial.showPosition>1
        positions(1,k) = lastposition(1);
        positions(2,k) = lastposition(2);
    end
    if thistrial.showPosition==3
        fingertipdistance = 0.5;
        fingertips(1,k) = positions(1,k) + fingertipdistance * attitudeMatrix(1,3) / (m.displayRangeX(k,2) - m.displayRangeX(k,1));
        fingertips(2,k) = positions(2,k) + fingertipdistance * attitudeMatrix(2,3) / (m.displayRangeY(k,4) - m.displayRangeY(k,3));
    end

    
end

if thistrial.showPosition==1
    lastposition(1) = lastposition(1) * experimentdata.screenInfo.screenRect(3);
    lastposition(2) = lastposition(2) * experimentdata.screenInfo.screenRect(4);
    Screen('DrawDots', experimentdata.screenInfo.curWindow, lastposition, 6, m.showPositionColor,[],1);
else
    positions(1,:) = positions(1,:) .* experimentdata.screenInfo.screenRect(3);
    positions(2,:) = positions(2,:) * experimentdata.screenInfo.screenRect(4);
    Screen('DrawDots', experimentdata.screenInfo.curWindow, positions, 6, m.showPositionColor,[],1);
end

if thistrial.showPosition==3
    fingertips(1,:) = fingertips(1,:) .* experimentdata.screenInfo.screenRect(3);
    fingertips(2,:) = fingertips(2,:) * experimentdata.screenInfo.screenRect(4);
    Screen('DrawDots', experimentdata.screenInfo.curWindow, fingertips, 6, [255 0 0],[],1);
end

lastposition(3) = 0;