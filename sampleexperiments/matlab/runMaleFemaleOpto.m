% Run the MaleFemale optotrak version experiment
if ~exist('protocols/MaleFemaleOpto.xml','file')
    generateRDK;
end
e = experiment('protocols/MaleFemaleOpto.xml','results/MaleFemaleOpto/');

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
