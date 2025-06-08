% Show the last position recorded as a dot on the screen 
% If showPosition (set per trial) =1 -> show the actual position of the stylus on the tablet
%                                 =2 -> do nothing (for compatibility with liberty / force sensors)
%                                 =3 -> calculate position based on displayRangeX / displayRangeY / offsetX / offsetY

function [lastpositionVisual,thistrial] = showPosition(tc,thistrial,experimentdata,e,frame)

if isfield(thistrial,'lastpositionVisual') && ~isempty(thistrial.lastpositionVisual) && ~isnan(thistrial.lastpositionVisual(1))
    lastpositionVisual = thistrial.lastpositionVisual;
elseif isfield(thistrial,'lastposition') && ~isempty(thistrial.lastposition) && ~isempty(thistrial.lastpositionVisual) && ~isnan(thistrial.lastpositionVisual(1))
   lastpositionVisual(:,1) = thistrial.lastposition(:,1) * experimentdata.screenInfo.screenRect(3);
   lastpositionVisual(:,2) = (1-thistrial.lastposition(:,2)) * experimentdata.screenInfo.screenRect(4);
   thistrial.lastpositionVisual = lastpositionVisual;
else 
   [lastposition,thistrial] = getsampleVisual(tc,thistrial,frame);

   lastpositionVisual(:,1) = lastposition(:,1) * experimentdata.screenInfo.screenRect(3);
   lastpositionVisual(:,2) = (1-lastposition(:,2)) * experimentdata.screenInfo.screenRect(4);
   thistrial.lastposition = lastposition;
   thistrial.lastpositionVisual = lastpositionVisual;
end
% i.e. pressure > 1 (or not NaN) or always showing (pressure is set to 1 as 'default', it shouldn't happen in practice) 
if frame==1 || (~(thistrial.pressure>1) && tc.showPositionOnlyWhenTouching)
    thistrial.lastposition = [NaN NaN];
    thistrial.lastpoint = [NaN NaN];
    lastpositionVisual = thistrial.lastposition;
    return;
end

thistrial = showPositionCommon(tc,lastpositionVisual,thistrial,experimentdata,e,frame);

% If movementonset=1, then movement onset requires a movement in the last frame of greater than 0.005
% If movementonset=2, then pressure>0 is sufficient
if ~isempty(thistrial.movementonset) && thistrial.movementonset.type<0
    if (thistrial.movementonset.type==-1 && ~isempty(thistrial.lastx) && ((thistrial.lastx - lastposition(1))^2 + (thistrial.lasty - lastposition(2))^2) > 0.005) || ...
            thistrial.movementonset.type==-2
        thistrial.movementonset.type = frame;
    end
end

if ~isempty(thistrial.lastposition)
    thistrial.lastx = thistrial.lastposition(1);
    thistrial.lasty = thistrial.lastposition(2);
end