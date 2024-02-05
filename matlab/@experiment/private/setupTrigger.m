% SETUPTRIGGER - Setup trigger (e.g. for EMG recording)

function thistrial = setupTrigger(thistrial)

if ~isempty(thistrial.trigger)
    for k=1:numel(thistrial.trigger)
        if strcmp(thistrial.trigger{k}.type,'serial')
            % Nothing to do here for setting up serial trigger
        elseif strcmp(thistrial.trigger{k}.type,'parallel')
            % Nothing to do here for setting up parallel trigger
        elseif strcmp(thistrial.trigger{k}.type,'DAQ')
            % Nothing to do here for setting up DAQ trigger
        elseif strcmp(thistrial.trigger{k}.type,'serialportserver')
            % Nothing to do here for setting up serialport server trigger
        elseif strcmp(thistrial.trigger{k}.type,'arduino')
            % Nothing to do here for setting up arduino
        else
            error(['Unsupported trigger type: ' thistrial.trigger{k}.type]);
        end
        thistrial.trigger{k}.sent = 0;
        thistrial.trigger{k}.time = thistrial.trigger{k}.time;
        thistrial.trigger{k}.offTime = thistrial.trigger{k}.time + thistrial.trigger{k}.duration;
    end
end