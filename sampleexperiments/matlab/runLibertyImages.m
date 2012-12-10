% Run the LibertyImages experiment
if ~exist('protocols/LibertyImages.xml','file')
    generateLibertyImagesProtocol;
end
e = experiment('protocols/LibertyImages.xml','results/LibertyImages/');
runlibertyserver;
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
