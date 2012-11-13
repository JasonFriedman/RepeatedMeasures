% SETUPTRIGGER - Setup trigger (e.g. for EMG recording)

function [triggerSent,triggerTime,triggerOffTime] = setupTrigger(thistrial)
if ~isfield(thistrial,'triggerTime') || str2double(thistrial.triggerTime) < 0
    triggerSent = 2;
    triggerTime = 10^7;
    triggerOffTime = 10^7;
else
    triggerSent = 0;
    triggerTime = str2double(thistrial.triggerTime) / 1000;
    % turn off trigger after 50ms
    triggerOffTime = triggerTime + 50/1000;
end
