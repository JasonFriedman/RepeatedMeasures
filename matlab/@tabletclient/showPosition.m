% Show the last position recorded as a dot on the screen 
% If showPosition (set per trial) =1 -> show the actual position of the stylus on the tablet
%                                 =2 -> do nothing (for compatibility with liberty / force sensors)
%                                 =3 -> calculate position based on displayRangeX / displayRangeY / offsetX / offsetY

function [lastposition,thistrial] = showPosition(tc,thistrial,experimentdata,e,frame)
% get the current position
lastsample = getsample(tc);
% i.e. pressure > 0 or always showing
if lastsample(4)>0 || ~tc.showPositionOnlyWhenTouching
    lasts = lastsample;
else
    lastposition = [NaN NaN];
    return;
end

lastsample(2) = 1 - lastsample(2); % make y the usual way around

[lastposition,thistrial] = showPositionCommon(tc,lastsample(1:2),thistrial,experimentdata,e,frame);

% If movementonset=1, then movement onset requires a movement in the last frame of greater than 0.005
% If movementonset=2, then pressure>0 is sufficient
if ~isempty(thistrial.movementonset) && thistrial.movementonset.type<0
    if (thistrial.movementonset.type==-1 && ~isempty(thistrial.lastx) && ((thistrial.lastx - lastposition(1))^2 + (thistrial.lasty - lastposition(2))^2) > 0.005) || ...
            thistrial.movementonset.type==-2
        thistrial.movementonset.type = frame;
    end
end

thistrial.lastx = lastposition(1);
thistrial.lasty = lastposition(2);