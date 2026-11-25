% GENERATEPROTOCOL - generate protocol for a "mirror game" experiment
% generateProtocol(subject,inputDevice,version,flipped)
%
% subject should be a string
% inputDevice: 1 = tablet, 2 = tablet + gemsense
% version: 1=  regular, 2 = anti-tracking (with a line in the middle)
% flipped: 0 = no, 1 = yes (for upside down monitor)
% stimuli: 1 = regular (default), 2 = Rosenbaumm-like

function filename = generateProtocol(subject,inputDevice,version,flipped,stimuli)

if nargin<3
    version=1;
end

if nargin<4
    flipped = 0;
end

if nargin<5
    stimuli = 1;
end

rng('shuffle'); % Make sure order is really random

if ~exist('protocols','dir')
    mkdir('protocols');
end

if isnumeric(subject)
    subject = num2str(subject);
end

inputDeviceName = {'Tablet','TabletGemsense'};

v = {'','_version2'};

f = {'','_flipped'};

filename = ['protocols/protocol' inputDeviceName{inputDevice} subject v{version} f{flipped+1} '.xml'];

%offset1 = 0.4;
offset2 = 0.65; %0.75; % 0.6
if flipped
    offset2 = 1 - offset2;
end
%ellipsesize = [60 120];
ellipsesize = [72 144];

experimentDescription.setup.tablet.server = 'localhost';
experimentDescription.setup.tablet.port = 3009;
experimentDescription.setup.tablet.maxx = 48767; %60073;
experimentDescription.setup.tablet.maxy = 30479; %33965;
experimentDescription.setup.tablet.showPositionType = 'ellipse';
experimentDescription.setup.tablet.showPositionColor = [0 0 255];
experimentDescription.setup.tablet.showPositionSize = ellipsesize;
experimentDescription.setup.tablet.offsetX = 0;
experimentDescription.setup.tablet.offsetY = offset2;
if flipped==0
    experimentDescription.setup.tablet.displayRangeX = [0 1 0 0 0];
else
    experimentDescription.setup.tablet.displayRangeX = [1 0 0 0 0];
end
experimentDescription.setup.tablet.displayRangeY = [0 0 0 0 0];

if inputDevice==2
    experimentDescription.setup.redamber.server = 'localhost';
    experimentDescription.setup.redamber.port = 3026;
    experimentDescription.setup.redamber.showPositionType = 'none';
    experimentDescription.setup.redamber.addresses = {'00:80:98:DC:9E:44','00:80:98:DC:A0:08'}; % Tel Hashomer 1 & 2
    % Tel Hashomer #3: 00:80:98:DC:9E:77
end

numtrials = 11;
experimentDescription.setup.sounds{1} = 'gong.wav';
order = randperm(numtrials); % 3 trials in a random order

if version==1
    experimentDescription.setup.images = {'instructions_mirrorgame.png'};
else
    experimentDescription.setup.images = {'linemiddle.png'};
end

n=0;

n = n+1;
experimentDescription.trial{n}.stimulus.showImage.stimuli = 1;
experimentDescription.trial{n}.recordingTime = 0;
experimentDescription.trial{n}.recording = 0;
experimentDescription.trial{n}.starttrial = 'keyboard';

for trialnum=1:numtrials
    n = n+1;
    experimentDescription.trial{n}.starttrial = 'dontWait';
    experimentDescription.trial{n}.targetType = 'dummy';
    experimentDescription.trial{n}.filename = sprintf('trial%d',trialnum);
    %experimentDescription.trial{n}.stimulus.rectangle.rectanglesFilename = sprintf('rectangles%d.csv',order(trialnum));
    %experimentDescription.trial{n}.stimulus.rectangle.framesPerRectangle = 1;
    %experimentDescription.trial{n}.stimulus.rectangle.color = [255 0 0];
    if flipped==0
        if stimuli==1
            experimentDescription.trial{n}.stimulus.dots.dotsFilename = sprintf('dot%d.csv',order(trialnum));
        else
            experimentDescription.trial{n}.stimulus.dots.dotsFilename = sprintf('rosenbaum%d.csv',order(trialnum));
        end
    else
        if stimuli==1
            experimentDescription.trial{n}.stimulus.dots.dotsFilename = sprintf('dot%d_flipped.csv',order(trialnum));
        else
            experimentDescription.trial{n}.stimulus.dots.dotsFilename = sprintf('rosenbaum%d_flipped.csv',order(trialnum));
        end
    end
    experimentDescription.trial{n}.stimulus.dots.framesPerDot = 1;
    experimentDescription.trial{n}.stimulus.dots.color = [255 0 0];
    experimentDescription.trial{n}.stimulus.dots.size = ellipsesize;
    experimentDescription.trial{n}.stimulus.dots.type = 3;
    if version==2
        experimentDescription.trial{n}.backgroundImage = 1;
    end
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
        if any(inputDevice == [1 2])
            n = n+1;
            experimentDescription.trial{n}.stimulus.showText.text = 'Lift the pen';
            experimentDescription.trial{n}.recordingTime = 15;
            experimentDescription.trial{n}.recording = 0;
            experimentDescription.trial{n}.starttrial = 'dontWait';
            if version==2
                experimentDescription.trial{n}.backgroundImage = 1;
            end
        end
    end
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);
fprintf('Successfully generated %s\n', filename);