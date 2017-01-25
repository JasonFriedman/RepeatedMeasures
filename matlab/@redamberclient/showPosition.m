% Show the last position recorded as a dot on the screen 
% If showPosition (set per trial) =1 -> do nothing
%                                 =2 -> do nothing (for compatibility with liberty / force sensors)
%                                 =3 -> calculate position based on displayRangeX / displayRangeY / offsetX / offsetY

function [lastposition,thistrial] = showPosition(tc,thistrial,experimentdata,e,frame)

% Nothing to do here (yet)