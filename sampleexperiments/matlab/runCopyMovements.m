% Run the CopyMovements experiment
if ~exist('protocols/CopyMovements.xml','file')
    generateCopyMovementsProtocol;
end
e = experiment('protocols/CopyMovements.xml','results/copyMovements/');

devices = get(e,'devices');
if isfield(devices,'optotrak')
    runoptotrakserver;
else
    runkeyboardserver;
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
