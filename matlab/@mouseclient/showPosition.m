% SHOWPOSITION - show the position for the mouse
% If showPosition (set per trial) =1 -> show the actual position of the mouse
%                                 =2 -> do nothing (for compatibility with liberty / force sensors)
%                                 =3 -> calculate position based on displayRangeX / displayRangeY / offsetX / offsetY

function [lastposition,thistrial] = showPosition(m,thistrial,experimentdata,e,frame)
% get the current position
lastposition = getxyz(m);
lastposition(2) = 1 - lastposition(2); % make y the usual way around
thistrial.lastposition = lastposition;

[lastsampleVisual,thistrial] = calculateLastPosition(m,lastposition,thistrial,frame);

lastpositionVisual(:,1) = lastsampleVisual(:,1) * experimentdata.screenInfo.screenRect(3);
lastpositionVisual(:,2) = lastsampleVisual(:,2) * experimentdata.screenInfo.screenRect(4);

thistrial.lastpositionVisual = lastpositionVisual;

thistrial = showPositionCommon(m,lastpositionVisual,thistrial,experimentdata,e,frame);