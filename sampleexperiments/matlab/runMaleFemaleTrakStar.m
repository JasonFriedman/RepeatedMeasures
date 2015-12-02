% Run the MaleFemale trakStar version experiment
if ~exist('protocols/MaleFemaleTrakStar.xml','file')
    generateMaleFemaleTrakStarProtocol;
end
e = experiment('protocols/MaleFemaleTrakStar.xml','results/MaleFemaleTrakStar/');

devices = get(e,'devices');
if isfield(devices,'mouse')
    runmouseserver;
else
    runtrakStarserver;
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
