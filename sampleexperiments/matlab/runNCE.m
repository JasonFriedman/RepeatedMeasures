% Run the NCE experiment
if ~exist('protocols/NCE.xml','file')
    generateNCEProtocol;
end
e = experiment('protocols/NCE.xml','results/NCE/');

devices = get(e,'devices');
if isfield(devices,'keyboard')
    runkeyboardserver;
else
    runDAQserver;
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
