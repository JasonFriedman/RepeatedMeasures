% Run the MaleFemale experiment
if ~exist('protocols/MaleFemale.xml','file')
    generateMaleFemaleProtocol;
end
e = experiment('protocols/MaleFemale.xml','results/MaleFemale/');
runkeyboardserver;
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
