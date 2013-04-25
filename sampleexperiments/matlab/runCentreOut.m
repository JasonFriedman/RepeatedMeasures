% Run the CentreOut experiment
if ~exist('protocols/CentreOut.xml','file')
    generateCentreOutProtocol;
end
e = experiment('protocols/CentreOut.xml','results/CentreOut/');
% wait a few seconds for it to come up
runtabletserver;
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