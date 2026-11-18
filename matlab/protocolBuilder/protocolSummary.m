% PROTOCOLSUMMARY - print a summary of a protocol that is being built
%
% protocolSummary(p)
% s = protocolSummary(p)   returns the numbers instead (fields trials, recorded, minutes,
%                          devices, blocks)
%
% The duration is the sum of the recording times and waiting times of the trials with a
% fixed duration (trials that wait for a key press or a response take longer).
function varargout = protocolSummary(p)
d = p.description;
s.trials = numel(d.trial);
s.recorded = 0;
seconds = 0;
openEnded = 0;
for k=1:s.trials
    t = d.trial{k};
    if isfield(d,'common')
        f = fieldnames(d.common);
        for m=1:numel(f)
            t.(f{m}) = d.common.(f{m});
        end
    end
    if isfield(t,'filename') && ~(isfield(t,'recording') && t.recording==0)
        s.recorded = s.recorded + 1;
    end
    if isfield(t,'recordingTime') && isfinite(t.recordingTime) && t.recordingTime>0
        seconds = seconds + t.recordingTime;
    else
        openEnded = openEnded + 1;
    end
end
s.minutes = seconds/60;
schema = protocolSchema;
s.devices = intersect(fieldnames(d.setup),fieldnames(schema.devices))';
names = p.blocks;
names(cellfun(@isempty,names)) = {'(no block)'};
[s.blocks,first] = unique(names,'first');
[sorted,order] = sort(first); %#ok<ASGLU>
s.blocks = s.blocks(order);
if nargout>0
    varargout{1} = s;
    return;
end
fprintf('%d trials (%d recorded), devices: %s\n',s.trials,s.recorded,strjoin(s.devices,', '));
fprintf('At least %.1f minutes (%d trials have no fixed duration)\n',s.minutes,openEnded);
for k=1:numel(s.blocks)
    fprintf('  %-20s %d trials\n',s.blocks{k},sum(strcmp(names,s.blocks{k})));
end
