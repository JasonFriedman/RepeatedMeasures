% RUNEXPERIMENT
result = inputdlg('Subject number');

subject = result{1};

runlibertyserver(6,-1,1);
pause(5);

e = experiment('protocols/day1a.xml',['results/' subject]);
e = setupdevices(e);
r = runexperiment(e);