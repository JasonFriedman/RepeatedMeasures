% VALIDATE - validate the protocol
% i.e. Go through and make sure all the stimulus, start and response descriptions are valid

function validate(e)
experimentdata = readResources(e,1);
experimentdata.recordingStimuli = 0;

% Use some fake values so that it can validate
experimentdata.screenInfo.curWindow = [];
experimentdata.screenInfo.screenRect = [0 0 1280 720];

experimentdata = readVisualResources(e,experimentdata);

p = e.protocol;

if isempty(e.devices)
    error('There must be at least one recording device');
end
devicelist = fields(e.devices);
for k=1:length(devicelist)
    clientparameters = p.setup.(devicelist{k});
    % debug is set to -1 so that socketclient won't try to connect
    eval(['e.devices.' devicelist{k} ' = ' devicelist{k} 'client(clientparameters,e,-1);']);
end

count = 0;
for k=1:numel(p.trial)
    thistrial = readTrialParameters(e,p.trial{k},experimentdata,1);
    if ~isempty(thistrial.filename)
        count = count+1;
        filenames{count} = thistrial.filename;
    end
end

% Check for duplicate filenames (from
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/304505)
[un idx_last idx] = unique(filenames);
unique_idx = accumarray(idx(:),(1:length(idx))',[],@(x) {x});
if any(cellfun(@length,unique_idx)>1)
    for k=1:numel(unique_idx)
        if numel(unique_idx{k})>1
            fprintf('Filename %s is repeated %d times!\n',filenames{unique_idx{k}(1)},numel(unique_idx{k}));
        end
    end
    error('Repeated filenames: Data will be overwritten!');
end

