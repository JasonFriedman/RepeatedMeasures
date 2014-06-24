% Run the ShowHand experiment using emulation (without actually sampling)
if ~exist('protocols/ShowHandEmulated.xml','file')
    generateShowHandProtocol(1);
end
e = experiment('protocols/ShowHandEmulated.xml','results/ShowHand/');
e = setupdevices(e);

% If there are multiple screens, use screen 1
screens = Screen('screens');
if numel(screens)>1
    screenNum = 1;
else
    screenNum = 0;
end

r = runexperiment(e,[],screenNum);