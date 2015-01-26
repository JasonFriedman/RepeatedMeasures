% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m

function [toFinish,thistrial,experimentdata] = finishTrial(m,thistrial,experimentdata,e,lastposition)

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

toFinish = 0;
if numel(lastsample)>0    
    if m.up
        toFinish = lastsample(m.channel);
    else
        toFinish = ~lastsample(m.channel);
    end
end