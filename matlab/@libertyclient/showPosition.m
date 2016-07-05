% SHOWPOSITION - show the position for the liberty 

function [lastposition,thistrial] = showPosition(tc,thistrial,experimentdata,e,frame)

% get the current position
lastposition = getxyz(tc);
thistrial.lastposition = lastposition;

[lastsampleVisual,thistrial] = calculateLastPosition(tc,lastposition,thistrial,frame);

lastpositionVisual(:,1) = lastsampleVisual(:,1) * experimentdata.screenInfo.screenRect(3);
lastpositionVisual(:,2) = lastsampleVisual(:,2) * experimentdata.screenInfo.screenRect(4);

thistrial.lastpositionVisual = lastpositionVisual;

thistrial = showPositionCommon(tc,lastpositionVisual,thistrial,experimentdata,e,frame);
thistrial.lastx = lastposition(1);
thistrial.lasty = lastposition(2);