% GENERATEPROTOCOL - generate the experimental protocol for the experiment
% 
% filename = generateProtocol(subjectNum)
%
% This is intended to be run with the RepeatedMeasures software
% https://github.com/JasonFriedman/RepeatedMeasures
function filename = generateProtocol(subjectNum)

filename = sprintf('protocols/pendulum%d.xml',subjectNum);
filenametxt = sprintf('protocols/pendulum%d_trialorder.txt',subjectNum);

experimentDescription.setup.monitorWidth = 70; %cm
experimentDescription.setup.viewingDistance = 68; %cm
experimentDescription.setup.xshift = 0; % relative shift of fixation / targets

experimentDescription.setup.liberty.server = 'localhost';
experimentDescription.setup.liberty.port = 3015;
experimentDescription.setup.liberty.numsensors = 8;
experimentDescription.setup.liberty.recordOrientation = 1;
experimentDescription.setup.liberty.hemisphere = [1 0 0]; % positive x hemisphere

if ~exist('protocols','dir')
    mkdir('protocols');
end

    titles = {'Abd/add shoulder','Fle/ext shoulder','Ext/int rot shoulder',...
        'Pro/Sup elbow','Fle/ext elbow','Fle/ext wrist','Abd/add wrist'};
    shorttitles = {'AbAds','FEs','Rots',...
        'PSe','FEe','FEw','AbAdw'};

trialnum=0;

for k=1:numel(shorttitles)
    trialnum=trialnum+1;
    experimentDescription.trial{trialnum}.starttrial = 'keyboard';
    experimentDescription.trial{trialnum}.targetType = 'keyboard';
    experimentDescription.trial{trialnum}.textFeedback = 0;
    experimentDescription.trial{trialnum}.auditoryFeedback = 0;
    experimentDescription.trial{trialnum}.filename = sprintf('%s',shorttitles{k});
    experimentDescription.trial{trialnum}.stimulus.showText.text = titles{k};
    experimentDescription.trial{trialnum}.beep{1}.time = 1;
    experimentDescription.trial{trialnum}.beep{2}.time = 6;
    experimentDescription.trial{trialnum}.recordingTime = 7; % seconds   
end

names = {'No pendulum','Without attempting to move','Attempting to move','Longer pendulum (80cm)','Shorter pendulum (20cm)','Without sight'};

shortnames = {'nopendulum','no_attempt_movement','attempt_move','longer_pendulum','shorter_pendulum','without_sight'};

thisorder = 1:6;

fp = fopen(filenametxt,'w');
for k=1:numel(thisorder)
    trialnum=trialnum+1;
    experimentDescription.trial{trialnum}.recordingTime = 132;
    experimentDescription.trial{trialnum}.beep{1}.time = 1;
    experimentDescription.trial{trialnum}.beep{2}.time = 131;
    
    experimentDescription.trial{trialnum}.stimulus.showText.text = names{thisorder(k)};
    experimentDescription.trial{trialnum}.recording = 1;
    experimentDescription.trial{trialnum}.filename = shortnames{thisorder(k)};
    fprintf(fp,'trial%d = %s\n',trialnum,shortnames{thisorder(k)});
    experimentDescription.trial{trialnum}.starttrial = 'keyboard';
end

fclose(fp);

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);