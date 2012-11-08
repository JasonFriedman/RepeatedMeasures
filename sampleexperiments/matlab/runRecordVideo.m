% Run the recordVideo experiment
if ~exist('protocols/RecordVideo.xml','file')
    generateRecordVideoProtocol;
end
e = experiment('protocols/RecordVideo.xml','results/recordVideo/');

devices = get(e,'devices');
if isfield(devices,'optotrak')
    runoptotrakserver;
end

% wait a few seconds for it to come up
pause(10);
e = setupdevices(e);

% If there are multiple screens, use screen 1
screens = Screen('screens');
if numel(screens)>1
    screenNum = 1;
else
    screenNum = 0;
end

r = runexperiment(e,[],screenNum);
