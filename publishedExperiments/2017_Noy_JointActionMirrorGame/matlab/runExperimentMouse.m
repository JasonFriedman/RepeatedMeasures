% RUNEXPERIMENTMOUSE

result = inputdlg('Subject number');

subject = result{1};

% copyrectangles

generateProtocol(subject,1);

runmouseserver;
pause(10); % Give the mouse server time to start

if ~exist('results','dir')
    mkdir('results');
end
if ~exist('results/mouse/','dir')
    mkdir('results/mouse/');
end

e = experiment(['protocols/protocolMouse' subject '.xml'],['results/mouse/' subject]);
e = setupdevices(e);

% If there are multiple screens, use screen 1
screens = Screen('screens');
if numel(screens)>1
    screenNum = 1;
else
    screenNum = 0;
end

r = runexperiment(e,[],screenNum);

!taskkill /fi "Windowtitle eq MATLAB command window"