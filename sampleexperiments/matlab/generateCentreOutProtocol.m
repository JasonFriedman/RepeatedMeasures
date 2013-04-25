% GENERATECENTREOUTPROTOCOL - generate the protocol for the tablet centre out experiment

function generateCentreOutProtocol

filename = 'protocols/CentreOut.xml';

experimentDescription.setup.monitorWidth = 43.2; %cm
experimentDescription.setup.viewingDistance = 40; %cm
experimentDescription.setup.xshift = 0; % relative shift of fixation / targets

experimentDescription.setup.tablet.server = 'localhost';
experimentDescription.setup.tablet.port = 3009;
% tablet dimensions (in tablet coordinates)
experimentDescription.setup.tablet.maxx = 43600;
experimentDescription.setup.tablet.maxy = 32799;

starttrialPedal.pedal.joystickType = 2;
starttrialPedal.pedal.joystickButton = 3;

trialnum = 0;

trialnum = trialnum+1;

experimentDescription.trial{trialnum}.stimulus.showText.text = sprintf('Press pedal to start');
experimentDescription.trial{trialnum}.recordingTime = 0;
experimentDescription.trial{trialnum}.recording = 0;
experimentDescription.trial{trialnum}.starttrial = starttrialPedal;

for k=0:8
    trialnum = trialnum + 1;
    experimentDescription.trial{trialnum}.stimulus.showText.text = sprintf('Target %d',k);
    experimentDescription.trial{trialnum}.targetType.defineTarget.targetNum = k+1;
    experimentDescription.trial{trialnum}.recordingTime = inf;
    experimentDescription.trial{trialnum}.recording = 0;
    experimentDescription.trial{trialnum}.starttrial = 'dontWait';
end

for k=1:8
    trialnum = trialnum + 1;
    experimentDescription.trial{trialnum}.stimulus.showText.text = sprintf('0 to %d',k);
    experimentDescription.trial{trialnum}.targetType.pointToPoint.start = 1;
    experimentDescription.trial{trialnum}.targetType.pointToPoint.end = k+1;
    experimentDescription.trial{trialnum}.targetType.pointToPoint.repetitions = 10;
    experimentDescription.trial{trialnum}.recordingTime = 30;
    experimentDescription.trial{trialnum}.recording = 1;
    experimentDescription.trial{trialnum}.filename = sprintf('0%d',k);
    experimentDescription.trial{trialnum}.starttrial = starttrialPedal;
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);
