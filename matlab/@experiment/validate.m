% VALIDATE - validate the protocol
% i.e. Go through and make sure all the stimulus, start and response descriptions are valid

function validate(e)
experimentdata = readResources(e,1);
experimentdata.recordingStimuli = 0;
experimentdata = prepareStaircase(e,experimentdata,e.protocol);

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

for k=1:numel(p.trial)
    readTrialParameters(e,p.trial{k},experimentdata,1);
end
