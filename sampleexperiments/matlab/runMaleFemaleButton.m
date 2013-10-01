% Run the MaleFemaleButton experiment
if ~exist('protocols/MaleFemaleButton.xml','file')
    generateMaleFemaleButtonProtocol;
end
e = experiment('protocols/MaleFemaleButton.xml','results/MaleFemaleButton/');
runDAQserver;
% wait a few seconds for it to come up
pause(20);
e = setupdevices(e);

% If there are multiple screens, use screen 1
screens = Screen('screens');
if numel(screens)>1
    screenNum = 1;
else
    screenNum = 0;
end

r = runexperiment(e,[],screenNum);
