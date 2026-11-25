% RUNEXPERIMENT
% Either r = runExperiment and a gui will ask for the details, or
%
% r = runExperiment

function r = runExperiment

    r = [];
    
    a = stringinputgui('Which group?', ...
        'Group? (1-3)');
    if isempty(a)
        return;
    end
    
    group = str2double(a);
    
    if group<1 || group>3 || group~=round(group)
        error('Group must be 1, 2 or 3');
    end
    
    a = stringinputgui('Subject number','Subject number?');
    if isempty(a)
        return;
    end
    subjectNumber = str2double(a);
    
    part = questdlg('Which part to run?', ...
        'Part?', ...
        'pre', 'training', 'post','pre');
    if isempty(part)
        return;
    end
    
dirname = sprintf('results/group%d/subject%02d%s',group,subjectNumber,part);

if exist(dirname,'dir')
    error(['The directory ' dirname ' already exists. ' ...
        'Either delete it or pick another subject / part']);
end

xmlfilename = generateProtocol(part);

e = experiment(xmlfilename,dirname);

runtabletserver;
%runmouseserver;

pause(5);

e = setupdevices(e);

r = runexperiment(e);