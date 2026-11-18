% NUMPOSITIONVALUES - number of values used to calculate the position: x, y and z of each sensor
%
% [n,perSensor] = numPositionValues(lc)
% perSensor = 3: a one-row displayRangeX / displayRangeY of 7 columns is used for every
% sensor (see repeatRowsForSensors)
function [n,perSensor] = numPositionValues(lc)
n = 3 * lc.numsensors;
perSensor = 3;
