% GENERATESEQUENCELEARNINGPROTOCOL - generate the protocol for the SequenceLearning experiment
%
% generateSequenceLearningProtocol

function generateSequenceLearningProtocol(withOpto)

if nargin<1 || isempty(withOpto)
    withOpto = 1;
end

filename = 'protocols/SequenceLearning.xml';

experimentDescription.setup.keyboard.server = 'localhost';
experimentDescription.setup.keyboard.port = 3002;

if withOpto
    experimentDescription.setup.optotrak.numbermarkers = 4;
    experimentDescription.setup.optotrak.secondaryhost = 0;
    experimentDescription.setup.optotrak.collectionParameters.FrameFrequency = 200;
    experimentDescription.setup.optotrak.collectionParameters.MarkerFrequency = 3000;
    experimentDescription.setup.optotrak.collectionParameters.Threshold = 30;
    experimentDescription.setup.optotrak.collectionParameters.MinimumGain = 160;
    experimentDescription.setup.optotrak.collectionParameters.DutyCycle = 0.550;
    experimentDescription.setup.optotrak.collectionParameters.Voltage = 9.335;
    experimentDescription.setup.optotrak.server = 'localhost';
    experimentDescription.setup.optotrak.port = 3000;
end

experimentDescription.setup.images = {'sequence41324.png','sequence42314.png'};


sequence = 'ZBDFZ';

count = 1;
experimentDescription.trial{count}.stimulus.showText.text = 'Learn the sequence - 41324';
experimentDescription.trial{count}.recording = 0;
experimentDescription.trial{count}.recordingTime = 0;
experimentDescription.trial{count}.starttrial = 'keyboard';
% learn the sequence
count = count+1;
experimentDescription.trial{count}.stimulus.images.stimuli = [1,1,inf,0];
experimentDescription.trial{count}.targetType.keyboardsequence.sequence = 'ZBDFZ';
experimentDescription.trial{count}.targetType.keyboardsequence.repetitions = 4;
experimentDescription.trial{count}.filename = 'learning';
experimentDescription.trial{count}.recordingTime = 120;
experimentDescription.trial{count}.starttrial = 'dontWait';

count = count+1;
experimentDescription.trial{count}.stimulus.showText.text = 'Tests';
experimentDescription.trial{count}.recording = 0;
experimentDescription.trial{count}.recordingTime = 0;
experimentDescription.trial{count}.starttrial = 'keyboard';

% Test how fast
for n=1:4
    count = count+1;
    experimentDescription.trial{count}.stimulus.images.stimuli = [1,1,inf,0];
    experimentDescription.trial{count}.targetType.keyboardsequence.sequence = sequence;
    experimentDescription.trial{count}.targetType.keyboardsequence.repetitions = inf;
    experimentDescription.trial{count}.filename = ['test' num2str(n)];
    experimentDescription.trial{count}.recordingTime = 31;
    experimentDescription.trial{count}.starttrial.pedal.joystickType = 1;
    experimentDescription.trial{count}.beep{1}.time = 0; % a "default" beep at time 0
    experimentDescription.trial{count}.beep{2}.time = 30; % an ending beep
    experimentDescription.trial{count}.beep{2}.frequency = 800;
    experimentDescription.trial{count}.beep{2}.duration = .25;
end
tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);



