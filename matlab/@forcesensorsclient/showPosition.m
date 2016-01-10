% SHOWPOSITION - show the position for the force sensors (as a dot)

function [lastposition,thistrial] = showPosition(m,thistrial,experimentdata,e,frame)

% get the current position
lastsample = getsample(m);
lastsample = lastsample(2:end-1);

[lastposition,thistrial] = showPositionCommon(m,lastsample,thistrial,experimentdata,e,frame);