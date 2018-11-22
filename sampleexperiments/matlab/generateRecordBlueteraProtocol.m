% GENERATERECORDBLUETERAPROTOCOL - generate the protocol for the BlueTera experiment.
%
% generateRecordBlueteraProtocol
%

function generateRecordBlueteraProtocol

filename = 'protocols/RecordBluetera.xml';

experimentDescription.setup.monitorWidth = 70; %cm
experimentDescription.setup.viewingDistance = 68; %cm
experimentDescription.setup.xshift = 0; % relative shift of fixation / targets
experimentDescription.setup.images = 'video_instructions.jpg';

experimentDescription.setup.bluetera.addresses = {'f9:d1:b1:98:55:f7'}; % change as appropriate
experimentDescription.setup.bluetera.server = 'localhost';
experimentDescription.setup.bluetera.port = 3027;

n=0;

for trialnum=1:2
    n = n+1;
    experimentDescription.trial{n}.stimulus.showText.text = 'Press space to record';
    experimentDescription.trial{n}.starttrial = 'keyboard';
    experimentDescription.trial{n}.targetType = 'dummy';
    experimentDescription.trial{n}.recordingTime = 5;
    experimentDescription.trial{n}.filename = ['trial' num2str(n)'];
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);