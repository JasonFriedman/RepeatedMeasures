% RECTCENTER - stub: center of a rectangle [left top right bottom]
function [x,y] = RectCenter(r)
x = round(0.5*(r(1)+r(3)));
y = round(0.5*(r(2)+r(4)));
