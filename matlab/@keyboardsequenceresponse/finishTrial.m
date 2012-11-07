% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition)
toFinish = false;
devices = get(e,'devices');
lastsample = getsample(devices.keyboard);
if length(lastsample)<2
    return;
end
lastkeypress = lastsample(2);
if ~isfield(thistrial,'lastkeypress')
    thistrial.lastkeypress = 0;
end
if ~isfield(thistrial,'pressedString')
    thistrial.pressedString = '';
end
if thistrial.lastkeypress ~= lastkeypress && lastkeypress > 0
    thistrial.pressedString = [thistrial.pressedString lastkeypress];
    %fprintf(['Pressed string ' thistrial.pressedString '\n']);
    if length(thistrial.pressedString) >= length(r.sequence)*r.repetitions
        matches = strfind(thistrial.pressedString,r.sequence);
        if numel(matches)>=r.repetitions && sum(diff(matches)>=length(r.sequence))>= (r.repetitions-1)
            toFinish = true;
        end
    end
end
thistrial.lastkeypress = lastkeypress;

