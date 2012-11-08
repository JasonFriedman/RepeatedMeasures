% Run the RDK experiment
if ~exist('protocols/RDK.xml','file')
    generateRDK;
end
e = experiment('protocols/RDK.xml','results/RDK/');

devices = get(e,'devices');
if isfield(devices,'mouse')
    runmouseserver;
else
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
