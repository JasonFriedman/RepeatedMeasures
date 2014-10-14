% SETUPTRIGGER - Setup trigger (e.g. for EMG recording)

function thistrial = setupTrigger(thistrial)

if ~isempty(thistrial.trigger)
    for k=1:numel(thistrial.trigger)
        if strcmp(thistrial.trigger{k}.type,'serial')
            % Setting up serial trigger
        else
            error(['Unsupported trigger type: ' thistrial.trigger{k}.type]);
        end
        thistrial.trigger{k}.sent = 0;
        thistrial.trigger{k}.time = thistrial.trigger{k}.time;
        thistrial.trigger{k}.offTime = thistrial.trigger{k}.time + thistrial.trigger{k}.duration;
        
    end
end