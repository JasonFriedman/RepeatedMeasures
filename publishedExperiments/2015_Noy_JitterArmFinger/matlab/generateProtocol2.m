% GENERATEPROTOCOL2 - generate protocol for a "mirror game" experiment
% generateProtocol2(subject,inputDevice)
%
% subject should be a string
% inputDevice: 1 = mouse, 2 = tablet, 3 = liberty 

function generateProtocol2(subject,inputDevice)

rng('shuffle'); % Make sure order is really random

if ~exist('protocols','dir')
    mkdir('protocols');
end

if isnumeric(subject)
    subject = num2str(subject);
end

inputDeviceName = {'Mouse','Tablet','Liberty'};

filename = ['protocols/protocol' inputDeviceName{inputDevice} subject '.xml'];

if inputDevice==1
    experimentDescription.setup.mouse.server = 'localhost';
    experimentDescription.setup.mouse.port = 3003;
    experimentDescription.setup.mouse.maxx = 1920;
    experimentDescription.setup.mouse.maxy = 1080;
    experimentDescription.setup.mouse.showPositionType = 'rectangle';
    experimentDescription.setup.mouse.showPositionColor = [0 0 255];
elseif inputDevice==2
    experimentDescription.setup.tablet.server = 'localhost';
    experimentDescription.setup.tablet.port = 3009;
    experimentDescription.setup.tablet.maxx = 43600;
    experimentDescription.setup.tablet.maxy = 32799;
    experimentDescription.setup.tablet.showPositionType = 'rectangle';
    experimentDescription.setup.tablet.showPositionColor = [0 255 0];
elseif inputDevice==3
    experimentDescription.setup.liberty.server = 'localhost';
    experimentDescription.setup.liberty.port = 3015;
    experimentDescription.setup.liberty.numsensors = 1;
    experimentDescription.setup.liberty.recordOrientation = 1;
    experimentDescription.setup.liberty.displayRangeX = [0 0 0 0 0 0 0]; % [0 0 1/3];
    experimentDescription.setup.liberty.displayRangeY = [0 0 0 0 11 8 0]; % show movements 8 cm to 11 cm (above the cube)
    experimentDescription.setup.liberty.offsetX = 0.5;
    experimentDescription.setup.liberty.offsetY = 0;
    experimentDescription.setup.liberty.showPositionType = 'rectangle';
    experimentDescription.setup.liberty.showPositionColor = [0 255 0];
end

numtrials = 11;
experimentDescription.setup.sounds{1} = 'gong.wav';
order = [9:11 randperm(8)];

n=0;
for trialnum=1:numtrials
    n = n+1;
    experimentDescription.trial{n}.starttrial = 'dontWait';
    experimentDescription.trial{n}.targetType = 'dummy';
    experimentDescription.trial{n}.filename = sprintf('trial%d',trialnum);
    experimentDescription.trial{n}.stimulus.rectangle.rectanglesFilename = sprintf('rectangles%d.csv',order(trialnum));
    experimentDescription.trial{n}.stimulus.rectangle.framesPerRectangle = 1;
    experimentDescription.trial{n}.stimulus.rectangle.color = [255 0 0];
    experimentDescription.trial{n}.recordingTime = 60;
    if inputDevice==3 % liberty
        experimentDescription.trial{n}.showPosition = 1;
    else
        experimentDescription.trial{n}.showPosition = 5;
    end
    % The gong sounds after 1 s
    experimentDescription.trial{n}.playAudioFile.number = 1;
    experimentDescription.trial{n}.playAudioFile.starttime = 0;
        
    if trialnum < numtrials
        if inputDevice == 2
            n = n+1;
            experimentDescription.trial{n}.stimulus.showText.text = 'Lift the pen';
            experimentDescription.trial{n}.recordingTime = 10;
            experimentDescription.trial{n}.recording = 0;
            experimentDescription.trial{n}.starttrial = 'dontWait';
        end
    end
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);
fprintf('Successfully generated %s\n', filename);