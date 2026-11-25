% RUNEXPERIMENT
result = inputdlg('Subject number');

subject = result{1};

thedir = ['results/day1b/' subject];
if exist(thedir,'dir')
    error(['The directory ' thedir ' already exists. Delete it or pick a different subject number.']);
end


runlibertyserver(6,-1,1);
pause(5);

e = experiment('protocols/day1b.xml',thedir);
e = setupdevices(e);
r = runexperiment(e);