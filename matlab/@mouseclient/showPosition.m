% SHOWPOSITION - show the position for the mouse
% If showPosition (set per trial) =1 -> show the actual position of the mouse
%                                 =2 -> do nothing (for compatibility with liberty / force sensors)
%                                 =3 -> calculate position based on displayRangeX / displayRangeY / offsetX / offsetY

function [lastposition,thistrial] = showPosition(m,thistrial,experimentdata,e,frame)
% get the current position
lastsample = getsample(m);
lastsample(2) = 1 - lastsample(2); % make y the usual way around

[lastposition,thistrial] = showPositionCommon(m,lastsample,thistrial,experimentdata,e,frame);