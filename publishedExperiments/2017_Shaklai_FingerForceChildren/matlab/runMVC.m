% runMVC

function r = runMVC(subject)

if nargin<1 || isempty(subject)
    error('Must specify the subject number / name as the first parameter');
end

%runforcesensorsserver('[0 0 0 0 0;1 1 1 1 1]',5);
runforcesensorsserver('[0 0 0 0 ;1 1 1 1]',4);
pause(15);

e = experiment('protocols/MVC.xml',['results/MVC/' subject]);
e = setupdevices(e);

r = runexperiment(e);

!taskkill /fi "Windowtitle eq MATLAB command window"