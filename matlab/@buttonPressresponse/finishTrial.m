% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m
% It will finish the trial if either the 'q' key is pressed, or a button is pressed

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition)
toFinish = false;
[keyIsDown, secs, keycode] = KbCheck;
if ~isempty(find(keycode,1)) && (find(keycode,1)==KbName('q') || find(keycode,1)==KbName('n'))
    toFinish = true;
end

devices = get(e,'devices');

thissample = getsample(devices.DAQ);

% ignore the first (timestamp) and last (event stamp) values
if any(thissample(2:end-1))
    toFinish = true;
end
