% GENERATETMSTriggerProtocol - generate the protocol file for the TMSTrigger experiment
%
% generateTMSTriggerProtocol

function generateTMSTriggerProtocol

filename = 'protocols/TMSTrigger.xml';

experimentDescription.setup.monitorWidth = 70; %cm
experimentDescription.setup.viewingDistance = 68; %cm
experimentDescription.setup.xshift = 0; % relative shift of fixation / targets

experimentDescription.setup.optotrak.markers = 2;
experimentDescription.setup.optotrak.server = 'localhost';
experimentDescription.setup.optotrak.serverPort = 3000;
experimentDescription.setup.optotrak.primaryHost = 1;
experimentDescription.setup.optotrak.frameFrequency = 200;
experimentDescription.setup.optotrak.markerFrequency = 3000;
experimentDescription.setup.optotrak.threshold = 30;
experimentDescription.setup.optotrak.minimumGain = 160;
experimentDescription.setup.optotrak.dutyCycle = 0.550;
experimentDescription.setup.optotrak.voltage = 9.335;
stimulus.VCRDM.percentCoherent = 50;
stimulus.VCRDM.direction = 1;
stimulus.VCRDM.numFrames = 20;
stimulus.VCRDM.speed = 5;
starttrial = 'pedal';
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

