% RUNEXPERIMENT
% Either r = runExperiment and a gui will ask for the details, or
%
% r = runExperiment(group,day,subjectNumber,part)
%
% This is necessary when showing the videos (i.e. training for group 3 & 4)
% e.g.
% r = runExperiment(3,1,999,'training');

function r = runExperiment(group,day,subjectNumber,part)

if nargin==0
    
    r = [];
    
    a = stringinputgui('Which group?', ...
        'Group? (1-4)');
    if isempty(a)
        return;
    end
    
    group = str2double(a);
    
    if group<1 || group>4 || group~=round(group)
        error('Group must be 1, 2, 3 or 4');
    end
    
    ButtonName = questdlg('Which Day?', ...
        'Day?', ...
        '1', '2','1');
    if isempty(ButtonName)
        return;
    end
    
    day = str2double(ButtonName);
    
    a = stringinputgui('Subject number','Subject number?');
    if isempty(a)
        return;
    end
    subjectNumber = str2double(a);
    
    if day==1
        part = questdlg('Which part to run?', ...
            'Part?', ...
            'pre', 'training', 'post','pre');
    elseif day==2
        part = questdlg('Which part to run?', ...
            'Part?', ...
            'pre', 'reverse', 'scaled','pre');
    end
    if isempty(part)
        return;
    end
    
else
    if group<1 || group>4 || group~=round(group)
        error('Group must be 1, 2, 3 or 4');
    end
    if ~any(day==[1 2])
        error('Day must be 1 or 2');
    end
    if ~any(strcmp(part,{'pre', 'training', 'post','reverse','scaled'}))
        error('Part must be one of pre, training, post, reverse or scaled');
    end
   
end

dirname = sprintf('results/group%d/subject%02dday%d%s',group,subjectNumber,day,part);

if exist(dirname,'dir')
    error(['The directory ' dirname ' already exists. ' ...
        'Either delete it or pick another subject / part']);
end

triggerType = 0; % 0 = none, 1 = DAQ
if group==1 && strcmp(part,'training')
    % Get the time from the trials already run
    files = dir(sprintf('results/group%d/subject%02dday%dpre/trialinfo_pre*.mat',group,subjectNumber,day));
    if isempty(files)
        error('Cannot find files from pretest for this subject');
    end
    for k=1:numel(files)
        load(sprintf('results/group%d/subject%02dday%dpre/%s',group,subjectNumber,day,files(k).name));
        if isfield(thistrial,'startedStopping')
            trialduration(k) = thistrial.startedStopping -  thistrial.frameInfo.startFrame(1) - 1.5;
        else
            trialduration(k) = NaN;
        end
    end
    xmlfilename = generateProtocol(group,2,triggerType,subjectNumber,nanmean(trialduration));
else
    xmlfilename = sprintf('protocols/coarticulation_group%d_%s.xml',group,part);
end


Screen('Preference','SkipSyncTests',1);

e = experiment(xmlfilename,dirname);

%runtabletserver;
runmouseserver;

pause(5);

e = setupdevices(e);

r = runexperiment(e);