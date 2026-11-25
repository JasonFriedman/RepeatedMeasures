% RUNEXPERIMENT - run the experiment
%
% This is intended to be run with the RepeatedMeasures software
% https://github.com/JasonFriedman/RepeatedMeasures
result = stringinputgui('Subject number?','Subject number?');

subject = str2double(result);

directory = sprintf('results/subject%d',subject);

if exist(directory,'dir')
    error(['Directory ' directory ' already exists. Delete or use a different number']);
end

filename = generateProtocol(subject);

runlibertyserver(8,-1,1);
pause(5);

e = experiment(filename,directory);
e = setupdevices(e);
r = runexperiment(e);