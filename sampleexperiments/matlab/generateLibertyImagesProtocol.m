% GENERATEQUESTIMAGESPROTOCOL - generate the protocol file for the QuestImages experiment
%
% generateQuestImagesProtocol

function generateLibertyImagesProtocol

filename = 'protocols/LibertyImages.xml';

experimentDescription.setup.monitorWidth = 70; %cm
experimentDescription.setup.viewingDistance = 68; %cm
experimentDescription.setup.xshift = 0; % relative shift of fixation / targets

% to be completed
experimentDescription.setup.images = {'Female1.png','Female2.png','Male1.png','Male2.png','cb.png'};
%stimulus.images.stimuli = 1;
starttrial.targetInSpace.target = 1;
response.targetInSpace.targets = [2 3];

experimentDescription.setup.liberty.server = 'localhost';
experimentDescription.setup.liberty.port = 3015;
experimentDescription.setup.liberty.numsensors = 1;

imagenum = [1:4 1:4];
imagenum = imagenum(randperm(8));
noiselevel = 0.2;

trialnum = 0;
texts = {'Left target','Right target','Starting position'};
for targetSetup = [3 1 2]
    trialnum = trialnum + 1;    
    experimentDescription.trial{trialnum}.stimulus.showText.text = texts{targetSetup};
    experimentDescription.trial{trialnum}.recording = 0;
    experimentDescription.trial{trialnum}.recordingTime = inf;
    experimentDescription.trial{trialnum}.targetType.defineTarget.targetNum = targetSetup;
    experimentDescription.trial{trialnum}.starttrial = 'dontWait';
end

trialnum = trialnum+1;
experimentDescription.trial{trialnum}.stimulus.showText.text = 'Ready?';
experimentDescription.trial{trialnum}.recording = 0;
experimentDescription.trial{trialnum}.recordingTime = 0;
experimentDescription.trial{trialnum}.targetType.defineTarget.targetNum = targetSetup;
experimentDescription.trial{trialnum}.starttrial = 'keyboard';

images = [1 1 2 2 3 3 4 4]; % show each image twice
target = [2 2 2 2 1 1 1 1]; % correct answer (first 4 female, next 4 male)
numtrials = length(images);
neworder = randperm(numtrials); % come up with a new ordering
cb = 5;

for k=1:numel(images)
    trialnum = trialnum+1;
    experimentDescription.trial{trialnum}.stimulus.images.stimuli = [images(neworder(k)),1,18,0.01;cb,19,102,0];
    experimentDescription.trial{trialnum}.targetNum = target(neworder(k));
    experimentDescription.trial{trialnum}.filename = sprintf('%d_%d',images(neworder(k)),k);
    % Record for 4 seconds in a trial
    experimentDescription.trial{trialnum}.recordingTime = 4;
    % Wait for this long (in seconds) after trial is started but before showing stimulus
    experimentDescription.trial{trialnum}.waitTimeBefore = 2;

    experimentDescription.trial{trialnum}.targetType.targetInSpace.targets = [1 2];
    % start trials by putting finger at start location
    experimentDescription.trial{trialnum}.starttrial.targetInSpace.target = 3;
    experimentDescription.trial{trialnum}.textFeedback = 1;
end
trialnum = trialnum + 1;
experimentDescription.trial{trialnum}.stimulus.showText.text = 'Experiment finished!';
experimentDescription.trial{trialnum}.recordingTime = 0;
experimentDescription.trial{trialnum}.recording = 0;
experimentDescription.trial{trialnum}.starttrial = 'keyboard';

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);