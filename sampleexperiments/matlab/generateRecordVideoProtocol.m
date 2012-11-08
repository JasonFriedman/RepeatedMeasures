% GENERATERECORDVIDEOPROTOCOL - generate the protocol for the RecordVideo experiment.
%
% This records simultanesouly from the optotrak and a video camera (webcam)
%
% generateRecordVideoProtocol
%
% To use this program, you need to first run a 'hacked' version of "AmCap"
% (contact write.to.jason@gmail.com if you need a copy), which will take
% commands via a socket. The files will be saved in the directory in which
% AmCap.exe is run

function generateRecordVideoProtocol

filename = 'protocols/RecordVideo.xml';

experimentDescription.setup.monitorWidth = 70; %cm
experimentDescription.setup.viewingDistance = 68; %cm
experimentDescription.setup.xshift = 0; % relative shift of fixation / targets
experimentDescription.setup.images = 'video_instructions.jpg';

experimentDescription.setup.optotrak.numbermarkers = 2;
experimentDescription.setup.optotrak.server = 'localhost';
experimentDescription.setup.optotrak.port = 3000;
experimentDescription.setup.optotrak.secondaryhost = 0;
experimentDescription.setup.optotrak.collectionParameters.FrameFrequency = 200;
experimentDescription.setup.optotrak.collectionParameters.MarkerFrequency = 3000;
experimentDescription.setup.optotrak.collectionParameters.Threshold = 30;
experimentDescription.setup.optotrak.collectionParameters.MinimumGain = 160;
experimentDescription.setup.optotrak.collectionParameters.DutyCycle = 0.550;
experimentDescription.setup.optotrak.collectionParameters.Voltage = 9.335;

experimentDescription.setup.video.server = 'localhost';
experimentDescription.setup.video.port = 4444;

texts = {'Move arm left to right','Move arm up and down'};
response = 'dummy';

n=1;
experimentDescription.trial{n}.stimulus.showImage.stimuli = 1;
experimentDescription.trial{n}.starttrial = 'keyboard';
experimentDescription.trial{n}.recording = 0;
experimentDescription.trial{n}.recordingTime = 0;

for trialnum=1:2
    n = n+1;
    experimentDescription.trial{n}.stimulus.showText.text = texts{trialnum};
    experimentDescription.trial{n}.starttrial.pedal.joystickType = 1;
    experimentDescription.trial{n}.targetType = response;
    experimentDescription.trial{n}.recordingTime = 3;
    experimentDescription.trial{n}.filename = ['trial' num2str(n)'];
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);