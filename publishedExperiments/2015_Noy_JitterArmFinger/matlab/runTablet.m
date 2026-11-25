function r = runTablet(subject)

runtabletserver;
pause(15);

e = experiment(['protocols/copyRectanglesTablet' subject '.xml'],['results/tablet/' subject]);
e = setupdevices(e);

r = runexperiment(e);

!taskkill /fi "Windowtitle eq MATLAB Command Window"
