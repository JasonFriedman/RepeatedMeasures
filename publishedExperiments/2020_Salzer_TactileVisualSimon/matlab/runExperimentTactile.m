% RUNEXPERIMENT - run the experiment

runlibertyserver(1,-1,1);

result = stringinputgui('Subject number','Subject number?');

if isempty(result)
    return;
end

subjectNum = result;

generateProtocol(subjectNum,0,1);

%e = experiment(['protocols/simonVisual' subjectNum '.xml'],['results/simonVisual/' subjectNum '/']);
e = experiment(['protocols/simonTactile' subjectNum '.xml'],['results/simonTactile/' subjectNum '/']);

e = setupdevices(e);

r = runexperiment(e);

