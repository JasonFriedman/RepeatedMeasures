% generate the protocol - session = 1, 2 or 3
%
%
function generateProtocol(session)

if nargin==0 || isempty(session)
    generateProtocol(1);
    generateProtocol(2);
    generateProtocol(3);
    return;
end

if session==1
    filename = 'protocols/day1a.xml';
    sequence1 = '41324';
    name1 = 'A';
    sequence1matrix = [4 1 3 2 4];
elseif session==2
    filename = 'protocols/day1b.xml';
    sequence1 = '42314';
    %sequence2 = '41324';
    name1 = 'B';
    %name2 = 'B';
    sequence1matrix = [4 2 3 1 4];
else
    filename = 'protocols/day2.xml';
    sequence1 = '41324';
    sequence2 = '42314';
    sequence3 = '42314';
    sequence4 = '41324';
    name1 = 'A';
    name2 = 'B';
    name3 = 'B_RH';
    name4 = 'A_RH';
end

experimentDescription.setup.monitorWidth = 70; %cm
experimentDescription.setup.viewingDistance = 68; %cm
experimentDescription.setup.xshift = 0; % relative shift of fixation / targets

experimentDescription.setup.liberty.server = 'localhost';
experimentDescription.setup.liberty.port = 3015;
experimentDescription.setup.liberty.numsensors = 6; %12;
experimentDescription.setup.liberty.recordOrientation = 1;
experimentDescription.setup.liberty.hemisphere = [0 0 1]; % positive z hemisphere

%touchThreshold = 2;
%untouchThreshold = 3;

if ~exist('protocols','dir')
    mkdir('protocols');
end

% Just show the fingertips
% displayRangeX(1,:) = [0 60 0 0 0 0 0];
% displayRangeX(2,:) = displayRangeX(1,:);
% displayRangeX(3,:) = displayRangeX(1,:);
% displayRangeX(4,:) = displayRangeX(1,:);
% displayRangeX(5,:) = displayRangeX(1,:);
% displayRangeX(6,:) = displayRangeX(1,:);
% 
% displayRangeY(1,:) = [0 0 60 0 0 0 0];
% displayRangeY(2,:) = displayRangeY(1,:);
% displayRangeY(3,:) = displayRangeY(1,:);
% displayRangeY(4,:) = displayRangeY(1,:);
% displayRangeY(5,:) = displayRangeY(1,:);
% displayRangeY(6,:) = displayRangeY(1,:);
% 
% experimentDescription.setup.liberty.displayRangeX = displayRangeX;
% experimentDescription.setup.liberty.displayRangeY = displayRangeY;

trialnum=0;

% trialnum=trialnum+1;
% experimentDescription.trial{trialnum}.recordingTime = 3;
% experimentDescription.trial{trialnum}.stimulus.showText.text = 'Finger opposition check';
% experimentDescription.trial{trialnum}.recording = 0;

% for k=1:1
%     trialnum=trialnum+1;
%     experimentDescription.trial{trialnum}.recordingTime = inf;
%     experimentDescription.trial{trialnum}.stimulus.fingerOppositionSequence.feedbackType = 2;
%     experimentDescription.trial{trialnum}.targetType.fingerOppositionSequence.sequence = [1 2 3 4]; % ignored
%     experimentDescription.trial{trialnum}.targetType.fingerOppositionSequence.repetitions = 100;
%     experimentDescription.trial{trialnum}.targetType.fingerOppositionSequence.fingermarkers = 1:5;
%     experimentDescription.trial{trialnum}.targetType.fingerOppositionSequence.touchThreshold = touchThreshold;
%     experimentDescription.trial{trialnum}.targetType.fingerOppositionSequence.untouchThreshold = untouchThreshold;
%     experimentDescription.trial{trialnum}.recording = 0;
%     %experimentDescription.trial{trialnum}.filename = sprintf('trial%d',trialnum);
% end

if session==1 || session==2
    
    trialnum=trialnum+1;
    experimentDescription.trial{trialnum}.recordingTime = 0;
    experimentDescription.trial{trialnum}.stimulus.showText.text = ['Finger opposition ' sequence1 ' (* 2)'];
    experimentDescription.trial{trialnum}.recording = 0;
    experimentDescription.trial{trialnum}.starttrial = 'keyboard';
    
    for k=1:1
        trialnum=trialnum+1;
        experimentDescription.trial{trialnum}.recordingTime = 30;
        experimentDescription.trial{trialnum}.stimulus = 'none';
        experimentDescription.trial{trialnum}.targetType.fingerOppositionSequence.sequence = sequence1matrix; %[4 1 3 2 4];
        experimentDescription.trial{trialnum}.targetType.fingerOppositionSequence.repetitions = 2;
        experimentDescription.trial{trialnum}.targetType.fingerOppositionSequence.fingermarkers = 1:5;
        experimentDescription.trial{trialnum}.recording = 1;
        experimentDescription.trial{trialnum}.filename = sprintf('practice');
    end
    
end

% pre-test
if session==1
    [experimentDescription,trialnum] = dotest('Pre-test ',sequence1,sprintf('pretest_%c%d',name1,session),experimentDescription,trialnum,0);
elseif session==3
    [experimentDescription,trialnum] = dotest('LH test ',sequence1,sprintf('pretest_%c%d',name1,session),experimentDescription,trialnum,0);
end

if session==1 || session==2
    for k=1:10
        trialnum=trialnum+1;
        experimentDescription.trial{trialnum}.recordingTime = 0;
        experimentDescription.trial{trialnum}.stimulus.showText.text = ['Training ' num2str(k) ':' sequence1];
        experimentDescription.trial{trialnum}.starttrial = 'keyboard';
        experimentDescription.trial{trialnum}.recording = 0;
        
        trialnum=trialnum+1;
        experimentDescription.trial{trialnum}.recordingTime = 43;
        experimentDescription.trial{trialnum}.stimulus = 'none';
        for m=1:16
            experimentDescription.trial{trialnum}.beep{m}.time = 2.5 * m; % first beep at 2.5 seconds, then every 2.5 sec
        end
        experimentDescription.trial{trialnum}.recording = 1;
        experimentDescription.trial{trialnum}.filename = sprintf('training_%c%dr%d',name1,session,k);
        
        trialnum=trialnum+1;
        experimentDescription.trial{trialnum}.recordingTime = 30;
        experimentDescription.trial{trialnum}.stimulus.showText.text = 'Wait . . .';
        experimentDescription.trial{trialnum}.recording = 0;
    end
end

% post-test
if session==1
    [experimentDescription,trialnum] = dotest('Post-test ',sequence1,sprintf('posttest_%s%d',name1,session),experimentDescription,trialnum,1);
% for session 3, all are pre-test

elseif session==3
    [experimentDescription,trialnum] = dotest('LH test ',sequence2,sprintf('pretest_%s%d',name2,session),experimentDescription,trialnum,1);
    [experimentDescription,trialnum] = dotest('RH test ',sequence3,sprintf('pretest_%s%d',name3,session),experimentDescription,trialnum,1);
    [experimentDescription,trialnum] = dotest('RH test ',sequence4,sprintf('pretest_%s%d',name4,session),experimentDescription,trialnum,1);
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [experimentDescription,trialnum] = dotest(name,sequence,fnbase,experimentDescription,trialnum,skiplastbreak)

for k=1:4
    trialnum=trialnum+1;
    experimentDescription.trial{trialnum}.recordingTime = 0;
    experimentDescription.trial{trialnum}.stimulus.showText.text = [name num2str(k) ':' sequence];
    experimentDescription.trial{trialnum}.starttrial = 'keyboard';
    experimentDescription.trial{trialnum}.recording = 0;
    
    trialnum=trialnum+1;
    experimentDescription.trial{trialnum}.recordingTime = 31;
    experimentDescription.trial{trialnum}.stimulus = 'none';
    experimentDescription.trial{trialnum}.recording = 1;
    experimentDescription.trial{trialnum}.beep{1}.time = 0;
    experimentDescription.trial{trialnum}.beep{2}.time = 30;
    experimentDescription.trial{trialnum}.filename = sprintf('%sr%d',fnbase,k);
    
    if k<4 || ~skiplastbreak
        trialnum=trialnum+1;
        experimentDescription.trial{trialnum}.recordingTime = 50;
        experimentDescription.trial{trialnum}.stimulus.showText.text = 'Wait . . .';
        experimentDescription.trial{trialnum}.recording = 0;
    end
end
