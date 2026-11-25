% RUNEXPERIMENT

inputdevice=1; % 1 = force sensors, 2  = mouse

subject = stringinputgui('Subject number?','Subject number?');

resultsDir = ['results/' subject];

if exist(resultsDir,'dir')
    errordlg('Subject already exists. Delete the directory or pick another number',...
        'Subject already exists');
    return;
end

if inputdevice==1
    r1 = runMVC(subject);
    MVC = calculateMVC(subject);
    filename = generateProtocol(subject,MVC);
    runforcesensorsserver('[0 0 0 0;1 1 1 1]',4);
else
    filename = generateProtocol(subject,[],inputdevice);    
    runmouseserver;
end

e = experiment(filename,resultsDir);
pause(10);
e = setupdevices(e);

%r = runexperiment(e,1,2);
r = runexperiment(e);
!taskkill /fi "Windowtitle eq MATLAB command window"