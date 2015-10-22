% Show the last position recorded as a dot on the screen 
% If showPosition (set per trial) =1 -> do nothing
%                                 =2 -> do nothing (for compatibility with liberty / force sensors)
%                                 =3 -> calculate position based on displayRangeX / displayRangeY / offsetX / offsetY

function [lastposition,thistrial] = showPosition(tc,thistrial,experimentdata,e,frame)
% get the current position
lastsample = getxyz(tc);

[lastposition,thistrial] = showPositionCommon(tc,lastsample,thistrial,experimentdata,e,frame);

thistrial.lastx = lastposition(1);
thistrial.lasty = lastposition(2);