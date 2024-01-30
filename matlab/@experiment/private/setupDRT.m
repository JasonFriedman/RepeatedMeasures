% setupDRT - set up the DRT for this trial
function thistrial = setupDRT(thistrial,experimentdata)

count = 1;
thistrial.DRT.endlastDRT(count) = thistrial.DRT.starttime;
% states:
% 0 = waiting for next DRT event
% 1 = beeping
% 2 = finished for this trial
thistrial.DRT.state = 0; % waiting for next DRT event
thistrial.DRT.nextDRTonset(count) = (thistrial.DRT.maxTimeBetween - thistrial.DRT.minTimeBetween) * rand + thistrial.DRT.minTimeBetween;
beepNumber = thistrial.DRT.beepNumber;
%beepdata = MakeBeep(experimentdata.beeps{beepNumber}.frequency, experimentdata.beeps{beepNumber}.duration);
PsychPortAudio('FillBuffer', experimentdata.pahandle, experimentdata.beepbuffer{beepNumber});


