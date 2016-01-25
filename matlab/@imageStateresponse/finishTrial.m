% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition,frame)

if ~isfield(thistrial,'imageState')
    error('Must use images stimuli with state transitions to use imageStateresponse');
end

currentState = thistrial.imageState;

if currentState==r.state
    toFinish=1;
else
    toFinish=0;
end

[keyIsDown, secs, keycode] = KbCheck;
if ~isempty(find(keycode,1)) && (find(keycode,1)==KbName('q') || find(keycode,1)==KbName('n'))
    toFinish = true;
end

