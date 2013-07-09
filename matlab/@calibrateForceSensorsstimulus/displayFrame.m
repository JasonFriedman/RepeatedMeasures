% DISPLAYFRAME - draw a frame

function [thistrial,experimentdata,breakfromloop,thisstimulus] = displayFrame(thisstimulus,e,frame,thistrial,experimentdata)

breakfromloop = 0;

if thisstimulus.calibrationType==1
    thetext = 'Zeroing force sensors . . .';
elseif thisstimulus.calibrationType==2
    thetext = sprintf('sensor %d = %.3f kg',thisstimulus.calibrationSensor,thisstimulus.calibrationWeight);
end
drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,thetext,1);