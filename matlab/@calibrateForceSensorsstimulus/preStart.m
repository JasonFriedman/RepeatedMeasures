% PRESTART - any actions to show before the trial starts. Default is to do nothing

function preStart(s,experimentdata,thistrial,firsttime)

if s.calibrationType==1
    thetext = 'Zeroing force sensors . . .';
elseif s.calibrationType==2
    thetext = sprintf('sensor %d = %.3f kg',s.calibrationSensor,s.calibrationWeight);
end
drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,thetext,1);
