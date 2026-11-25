% GENERATEPROTOCOL - generate protocol for a "mirror game" experiment
% generateProtocol(subject,inputDevice)
%
% subject should be a string
% inputDevice: 1 = mouse, 2 = tablet, 3 = liberty 

function filename = generateProtocol(subject,inputDevice)

rng('shuffle'); % Make sure order is really random

if ~exist('protocols','dir')
    mkdir('protocols');
end

if isnumeric(subject)
    subject = num2str(subject);
end

inputDeviceName = {'Mouse','Tablet','Liberty'};

filename = ['protocols/protocol' inputDeviceName{inputDevice} subject '.xml'];

%offset1 = 0.4;
offset2 = 0.65; %0.75; % 0.6
%ellipsesize = [60 120];
ellipsesize = [72 144];

if inputDevice==1
    experimentDescription.setup.mouse.server = 'localhost';
    experimentDescription.setup.mouse.port = 3003;
    experimentDescription.setup.mouse.maxx = 1366; %1920;
    experimentDescription.setup.mouse.maxy = 768; %1080;
    experimentDescription.setup.mouse.showPositionType = 'ellipse';
    experimentDescription.setup.mouse.showPositionColor = [0 0 255];
    experimentDescription.setup.mouse.showPositionSize = ellipsesize;
    experimentDescription.setup.mouse.offsetX = 0;
    experimentDescription.setup.mouse.offsetY = offset2;
    experimentDescription.setup.mouse.displayRangeX = [0 1 0 0 0];
    experimentDescription.setup.mouse.displayRangeY = [0 0 0 0 0];
elseif inputDevice==2
    experimentDescription.setup.tablet.server = 'localhost';
    experimentDescription.setup.tablet.port = 3009;
    experimentDescription.setup.tablet.maxx = 43600;
    experimentDescription.setup.tablet.maxy = 32799;
    experimentDescription.setup.tablet.showPositionType = 'ellipse';
    experimentDescription.setup.tablet.showPositionColor = [0 0 255];
    experimentDescription.setup.tablet.showPositionSize = ellipsesize;
    experimentDescription.setup.tablet.offsetX = 0;
    experimentDescription.setup.tablet.offsetY = offset2;
    experimentDescription.setup.tablet.displayRangeX = [0 1 0 0 0];
    experimentDescription.setup.tablet.displayRangeY = [0 0 0 0 0];
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
order = randperm(numtrials); % 3 trials in a random order

n=0;
for trialnum=1:numtrials
    n = n+1;
    experimentDescription.trial{n}.starttrial = 'dontWait';
    experimentDescription.trial{n}.targetType = 'dummy';
    experimentDescription.trial{n}.filename = sprintf('trial%d',trialnum);
    %experimentDescription.trial{n}.stimulus.rectangle.rectanglesFilename = sprintf('rectangles%d.csv',order(trialnum));
    %experimentDescription.trial{n}.stimulus.rectangle.framesPerRectangle = 1;
    %experimentDescription.trial{n}.stimulus.rectangle.color = [255 0 0];
    experimentDescription.trial{n}.stimulus.dots.dotsFilename = sprintf('dot%d.csv',order(trialnum));
    experimentDescription.trial{n}.stimulus.dots.framesPerDot = 1;
    experimentDescription.trial{n}.stimulus.dots.color = [255 0 0];
    experimentDescription.trial{n}.stimulus.dots.size = ellipsesize;
    experimentDescription.trial{n}.stimulus.dots.type = 3;
    %experimentDescription.trial{n}.backgroundColor = [100 100 100];

    experimentDescription.trial{n}.recordingTime = 68;
    if inputDevice==1 % mouse
        experimentDescription.trial{n}.showPosition = 3;
    elseif inputDevice==3 % liberty
        experimentDescription.trial{n}.showPosition = 1;
    else % tablet
        experimentDescription.trial{n}.showPosition = 3;
    end
    % The gong sounds after 1 s
    experimentDescription.trial{n}.playAudioFile.number = 1;
    experimentDescription.trial{n}.playAudioFile.starttime = 0;
        
    if trialnum < numtrials
        if inputDevice == 2
            n = n+1;
            experimentDescription.trial{n}.stimulus.showText.text = 'Lift the pen';
            experimentDescription.trial{n}.recordingTime = 15;
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