% GENERATEPROTOCOL
%
% generateProtocol(part)
%
% part = 'pre','training' or 'post'

function filename = generateProtocol(part)

filename = sprintf('protocols/%s.xml',part);

% The computer cannot keep up with 60Hz so use 20 Hz instead
%experimentDescription.setup.framerate = 20;

partnames = {'pre','training','post'};

partnum = 0;
for k=1:3
    if strcmp(part,partnames{k})
        partnum = k;
    end
end
if partnum==0
    error('Unknown part');
end

shortnames = {'pre','tr','post'};

device = 1; % tablet
%device = 2; % mouse

screenwidth = 1920;
screenheight = 1080;

if device==1
    experimentDescription.setup.tablet.server = 'localhost';
    experimentDescription.setup.tablet.port = 3009;
    % tablet dimensions (in tablet coordinates)
    experimentDescription.setup.tablet.maxx = 48767;
    experimentDescription.setup.tablet.maxy = 30479;
    experimentDescription.setup.tablet.showPositionType = 'dot';
    experimentDescription.setup.tablet.showPositionColor = [0 0 255];
elseif device==2
    experimentDescription.setup.mouse.server = 'localhost';
    experimentDescription.setup.mouse.port = 3003;
    % tablet dimensions (in tablet coordinates)
    experimentDescription.setup.mouse.maxx = screenwidth;
    experimentDescription.setup.mouse.maxy = screenheight;
    experimentDescription.setup.mouse.showPositionType = 'dot';
    experimentDescription.setup.mouse.showPositionColor = [0 0 255];
end
%experimentDescription.setup.images = {'4targetsallsmall.png','4targets1large.png','fixation.png','blankscreen.png'};

%experimentDescription.setup.images = {'4targetsallsmall.png','fixation.png','blankscreen.png'};

%fixation = 2;
%blankscreen = 3;

experimentDescription.setup.beeps{1}.frequency = 1000; %Hz = frequency of the BBC pips on the hour
experimentDescription.setup.beeps{1}.duration = 0.1; %s

if any(partnum==[1 3])
    numblocks = 1;
    trialsperblock = 40;
elseif partnum==2
    numblocks = 4;
    trialsperblock = 30; 
else
    error('Unknown block');
end
n=0;

offsets = [0 5];

for block=1:numblocks
    n=n+1;
    experimentDescription.trial{n}.stimulus.showText.text = sprintf('%s Block %d',shortnames{partnum},block);
    experimentDescription.trial{n}.stimulus.showText.color = [0 0 0];
    if device==1
        experimentDescription.trial{n}.starttrial = 'keyboard'; %'stylusButton'; %'mouseClick'; %'keyboard';
    else
         experimentDescription.trial{n}.starttrial = 'keyboard';
    end
    experimentDescription.trial{n}.targetType = 'dummy';
    experimentDescription.trial{n}.recordingTime = 0;
    experimentDescription.trial{n}.recording = 0;
    experimentDescription.trial{n}.showPosition = 1;
    experimentDescription.trial{n}.backgroundColor = [255 255 255];
    
    for trialnum=1:trialsperblock
        n=n+1;
        
        experimentDescription.trial{n}.stimulus = 'none';
        experimentDescription.trial{n}.targetType.stoppedMoving.duration = 0.5; % End trial after stopped for 0.5s
        experimentDescription.trial{n}.targetType.stoppedMoving.startDistance = 0.1;
        experimentDescription.trial{n}.recordingTime = 7;
        experimentDescription.trial{n}.recording = 1;
        experimentDescription.trial{n}.filename = sprintf('%s_block%d_trial%d',shortnames{partnum},block,trialnum);
        experimentDescription.trial{n}.starttrial = 'dontWait';
        experimentDescription.trial{n}.beep{1}.time = 1;
        experimentDescription.trial{n}.beep{1}.beepNumber = 1; 
    end
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);