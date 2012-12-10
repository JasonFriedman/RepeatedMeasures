% Run the CopyShapes experiment
if ~exist('protocols/CopyShapes.xml','file')
    generateCopyShapesProtocol;
end
e = experiment('protocols/CopyShapes.xml','results/CopyShapes/');
if isfield(get(e,'devices'),'mouse')
    runmouseserver;
else
    runtabletserver;
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