% HASSTARTED - has the trial started?
% Do not call directly, will be called by runexperiment

function [started,keyCode] = hasStarted(m,e,experimentdata,thistrial)

devices = get(e,'devices');
if isfield(devices,'DAQ')
    lastsample = getsample(devices.DAQ);
    if numel(lastsample)>1
        lastsample = lastsample(2:end);
    end
else
    MCtrigger = get(e,'MCtrigger');
    lastsample = getdata(MCtrigger);
    % convert to bits
    lastsample = bitget(lastsample,1:8);
end

started = 0;
if numel(lastsample)>0    
    if m.up
        started = lastsample(m.channel);
    else
        started = ~lastsample(m.channel);
    end
end

% check the keyboard also
[keyisdown,secs, keyCode ] = kbCheck(-1);
