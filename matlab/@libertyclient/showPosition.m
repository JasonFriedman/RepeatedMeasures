% SHOWPOSITION - show the position for the liberty (as a dot)

function [lastposition,thistrial] = showPosition(m,thistrial,experimentdata,e,frame)
% get the current position
lastsample = getsample(m); 

% [2 3 4] are the x y z coordinates. Subtract the "zero" if it has been recorded
if isfield(experimentdata,'targetPosition') && ~isempty(experimentdata.targetPosition)
    xyz = lastsample(2:4) - experimentdata.targetPosition(1,:);
else
    xyz = lastsample(2:4);
end

lastposition(1) = 0;
if (m.displayRangeX(2) ~= m.displayRangeX(1))
    lastposition(1) = lastposition(1) + (xyz(1) - m.displayRangeX(1)) /(m.displayRangeX(2) - m.displayRangeX(1));
end
if (m.displayRangeX(4) ~= m.displayRangeX(3))
   lastposition(1) = lastposition(1) +  (xyz(2) - m.displayRangeX(3)) /(m.displayRangeX(4) - m.displayRangeX(3));
end
if (m.displayRangeX(6) ~= m.displayRangeX(4))
   lastposition(1) = lastposition(1) + (xyz(3) - m.displayRangeX(5)) / (m.displayRangeX(6) - m.displayRangeX(5));
end
lastposition(1) = lastposition(1) * experimentdata.screenInfo.screenRect(3);

lastposition(2) = 0;
if (m.displayRangeY(2) ~= m.displayRangeY(1))
    lastposition(2) = lastposition(2) + (xyz(1) - m.displayRangeY(1)) /(m.displayRangeY(2) - m.displayRangeY(1));
end
if (m.displayRangeY(4) ~= m.displayRangeY(3))
   lastposition(2) = lastposition(2) +  (xyz(2) - m.displayRangeY(3)) /(m.displayRangeY(4) - m.displayRangeY(3));
end
if (m.displayRangeY(6) ~= m.displayRangeY(4))
   lastposition(2) = lastposition(2) + (xyz(3) - m.displayRangeY(5)) / (m.displayRangeY(6) - m.displayRangeY(5));
end
lastposition(2) = lastposition(2) * experimentdata.screenInfo.screenRect(4);

Screen('DrawDots', experimentdata.screenInfo.curWindow, lastposition, 6, [192 192 192],[],1);

lastposition(3) = 0;