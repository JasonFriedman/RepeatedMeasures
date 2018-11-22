% Run the recordBluetera experiment
if ~exist('protocols/RecordBluetera.xml','file')
    generateRecordBlueteraProtocol;
end
e = experiment('protocols/RecordBluetera.xml','results/recordBluetera/');

runblueteraserver;

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
