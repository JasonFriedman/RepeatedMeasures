% RUNEXPERIMENTTABLETFLIPPEDTRANSFER

%error('Use runExperimentTablet2');

subject = stringinputgui('Subject number','Subject number','');

if ~exist('results','dir')
    mkdir('results');
end
if ~exist('results/tablet/','dir')
    mkdir('results/tablet/');
end

outputDir = ['results/tablet/' subject];

if exist(outputDir,'dir')
    error(['Directory ' outputDir ' already exists. Delete or pick another number']);
end

% copyrectangles

filename = generateProtocol(subject,2,1,2);

runtabletserver;
pause(10); % Give the server time to start

e = experiment(filename,outputDir);
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