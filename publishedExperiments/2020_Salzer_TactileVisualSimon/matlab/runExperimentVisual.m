% RUNEXPERIMENT - run the experiment

runlibertyserver(1,-1,1);

result = inputdlg('Subject number');

subjectNum = result{1};


generateProtocol(subjectNum,0,0);

e = experiment(['protocols/simonVisual' subjectNum '.xml'],['results/simonVisual/' subjectNum '/']);
%e = experiment(['protocols/simonTactile' subjectNum '.xml'],['results/simonTactile/' subjectNum '/']);

e = setupdevices(e);

r = runexperiment(e);

