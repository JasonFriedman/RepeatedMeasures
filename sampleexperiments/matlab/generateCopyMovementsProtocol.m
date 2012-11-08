% GENERATECOPYMOVEMENTSPROTOCOL - generate the protocol for the CopyMovements experiment
%
% generateCopyMovementsProtocol

function generateCopyMovementsProtocol(withOpto)

if nargin<1 || isempty(withOpto)
    withOpto = 1;
end

filename = 'protocols/CopyMovements.xml';

experimentDescription = [];

experimentDescription.setup.monitorWidth = 70; %cm
experimentDescription.setup.viewingDistance = 68; %cm
experimentDescription.setup.xshift = 0; % relative shift of fixation / targets

if withOpto
    experimentDescription.setup.optotrak.numbermarkers = 2;
    experimentDescription.setup.optotrak.secondaryhost = 0;
    experimentDescription.setup.optotrak.collectionParameters.FrameFrequency = 200;
    experimentDescription.setup.optotrak.collectionParameters.MarkerFrequency = 3000;
    experimentDescription.setup.optotrak.collectionParameters.Threshold = 30;
    experimentDescription.setup.optotrak.collectionParameters.MinimumGain = 160;
    experimentDescription.setup.optotrak.collectionParameters.DutyCycle = 0.550;
    experimentDescription.setup.optotrak.collectionParameters.Voltage = 9.335;
    experimentDescription.setup.optotrak.server = 'localhost';
    experimentDescription.setup.optotrak.port = 3000;
else
    experimentDescription.setup.keyboard.server = 'localhost';
    experimentDescription.setup.keyboard.port = 3002;
end
stimulus = {'LR','UD'};

n = 0;
for trialnum=1:2
    n = n+1;
    experimentDescription.trial{n}.stimulus.video.filename = stimulus{trialnum};
    experimentDescription.trial{n}.starttrial.pedal.joystickType = 1;
    experimentDescription.trial{n}.targetType = 'dummy';
    experimentDescription.trial{n}.recordingTime = 3;
    experimentDescription.trial{n}.filename = ['trial' num2str(trialnum)];
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);


