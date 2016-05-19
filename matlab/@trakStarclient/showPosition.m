% Show the last position recorded as a dot on the screen 
% If showPosition (set per trial) =1 -> do nothing
%                                 =2 -> do nothing (for compatibility with liberty / force sensors)
%                                 =3 -> calculate position based on displayRangeX / displayRangeY / offsetX / offsetY

function [lastposition,thistrial] = showPosition(tc,thistrial,experimentdata,e,frame)
% get the current position
lastposition = getxyz(tc);
thistrial.lastposition = lastposition;

[lastsampleVisual,thistrial] = calculateLastPosition(m,lastposition,thistrial,frame);

lastpositionVisual(:,1) = lastsampleVisual(:,1) * experimentdata.screenInfo.screenRect(3);
lastpositionVisual(:,2) = lastsampleVisual(:,2) * experimentdata.screenInfo.screenRect(4);

thistrial.lastpositionVisual = lastpositionVisual;

thistrial = showPositionCommon(tc,lastpositionVisual,thistrial,experimentdata,e,frame);

thistrial.lastx = lastposition(1);
thistrial.lasty = lastposition(2);