% GENERATEQUESTIMAGESPROTOCOL - generate the protocol file for the QuestImages experiment
%
% generateQuestImagesProtocol

function generateLibertyImagesProtocol

filename = 'protocols/QuestImages.xml';

experimentDescription.setup.monitorWidth = 70; %cm
experimentDescription.setup.viewingDistance = 68; %cm
experimentDescription.setup.xshift = 0; % relative shift of fixation / targets

% to be completed
experimentDescription.setup.images = {'Female1.png','Female2.png','Male1.png','Male2.png','cb.png'};
%stimulus.images.stimuli = 1;
starttrial.targetInSpace.target = 1;
response.targetInSpace.targets = [2 3];

experimentDescription.setup.liberty.server = 'localhost';
experimentDescription.setup.liberty.port = 3020;
experimentDescription.setup.liberty.numsensors = 1;

imagenum = [1:4];

for trialnum=1:4
    experimentDescription.trial{n}.stimulus.images.stimuli = [5 1 30 1;
                                                              imagenum(n) 31 48 0.5];
    experimentDescription.trial{n}.starttrial = starttrial;
    experimentDescription.trial{n}.targetType = response;
    experimentDescription.trial{n}.recordingTime = 3;
    experimentDescription.trial{n}.filename = sprintf('%d_%d_%d',imagenum,noiselevel*100,trialnum);
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);