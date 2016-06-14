% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m
% This method should be overloaded by a child class if you want an
% ability to finish a trial early (say if a target has been reached)

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition,frame)
devices = get(e,'devices');
if isfield(devices,'keyboard')
    data = getsample(devices.keyboard);
    if numel(data)>1
        keypressed = data(2);
    else
        keypressed = [];
    end
else
    [keyIsDown, secs, keyCode] = KbCheck(-1);
    keypressed = find(keyCode);
    if isempty(keypressed)
        keypressed = -1;
    end
end

% If the trial was started with a keypress, need to make sure they released
% the key at sometime
if isa(thistrial.thisstarttrial,'keyboardstart') && ...
        (~isfield(thistrial,'releasedKey') || ~thistrial.releasedKey)
    % If thistrial.releasedKey is 1, it has been released
    % It has been released so OK to end (later)
    if numel(keypressed)==0 || keypressed(1)<=0
        thistrial.releasedKey = 1;
    else
        thistrial.releasedKey = 0;
    end
    % Set the key pressed to empty
    keypressed = -1;
end
if ~isempty(keypressed) && any(keypressed(1) == [r.keytopress KbName('q') KbName('n')])
    toFinish = 1;
    thistrial.kb_firstpressed = keypressed;
else
    toFinish = 0;
end
