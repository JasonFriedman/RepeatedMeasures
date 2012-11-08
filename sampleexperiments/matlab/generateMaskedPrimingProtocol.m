% GENERATEMASKEDPRIMINGPROTOCOL - generate the MaskedPriming protocol file.
%
% generateMaskedPrimingProtocol

function generateMaskedPrimingProtocol

experimentDescription = [];
filename = 'protocols/MaskedPriming.xml';

experimentDescription.setup.monitorWidth = 70; %cm
experimentDescription.setup.viewingDistance = 68; %cm
experimentDescription.setup.xshift = 0; % relative shift of fixation / targets

experimentDescription.setup.liberty.server = 'localhost';
experimentDescription.setup.liberty.port = 3015;
experimentDescription.setup.liberty.numsensors = 1;
stimulus.images.stimuli = 1;
starttrial.targetInSpace.target = 1;
response.targetInSpace.targets = [2 3];

experimentDescription.trial{1}.stimulus = stimulus;
experimentDescription.trial{1}.starttrial = starttrial;
experimentDescription.trial{1}.targetType = response;
experimentDescription.trial{1}.recordingTime = 3;

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);



