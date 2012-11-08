% Run the MouseWords experiment
if ~exist('protocols/MouseWords.xml','file')
    generateCopyShapesProtocol;
end
e = experiment('protocols/MouseWords.xml','results/MouseWords/');
runmouseserver;
% wait a few seconds for it to come up
pause(15);
e = setupdevices(e);

% If there are multiple screens, use screen 1
screens = Screen('screens');
if numel(screens)>1
    screenNum = 1;
else
    screenNum = 0;
end

r = runexperiment(e,[],screenNum);
