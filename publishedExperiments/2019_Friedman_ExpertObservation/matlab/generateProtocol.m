% GENERATEPROTOCOL
%
% generateProtocol(group,part,triggerType)
% generateProtocol(group,part,triggerType,subjectNum,time)
%
% group => 1 = training = 1/2 execution, 1/2 random dot
%          2 = training = just execution (double amount of other group)
%          3 = training = observation (regular speed)
%          4 = training = observation (1/3 speed)
% part => 1 = pretest, 2 = training, 3 = posttest, 4 = reverse, 5 = scaled
% triggerType => 0 = none, 1 = DAQ
%
% The second version is only for part=2, must also specify subject number
% and time (for displaying non-biological stimuli)

function filename = generateProtocol(group,part,triggerType,subjectNum,time)

if group==1 && part==2 && nargin<5
    error('For training, must specify subjectNum and time');
end

if triggerType==0
    %
elseif triggerType==1
    triggerTypeString = 'DAQ';
    experimentDescription.setup.MCtrigger = 1;
else
    error('Trigger type can be 0 or 1');
end

% The computer cannot keep up with 60Hz so use 20 Hz instead
experimentDescription.setup.framerate = 20;

partnames = {'pre','training','post','reverse','scaled'};
shortnames = {'pre','tr','post','reverse','scaled'};

if group==1 && part==2
    filename = sprintf('protocols/coarticulation_group%d_%s_%02d.xml',group,partnames{part},subjectNum);
    % generate the 'bouncing ball;
    %makeBouncingDotFile(experimentDescription.setup.framerate,time,sprintf('stimuli/bouncing%d.csv',subjectNum))
    % generate the random lines
    makeRandomLinesFile(experimentDescription.setup.framerate,time,sprintf('stimuli/lines%d.csv',subjectNum))
else
    filename = ['protocols/coarticulation_group' num2str(group) '_' partnames{part} '.xml'];
end

%device = 1; % tablet
device = 2; % mouse

screenwidth = 1536; %1920;
screenheight = 864; %1080;

if device==1
    experimentDescription.setup.tablet.server = 'localhost';
    experimentDescription.setup.tablet.port = 3009;
    % tablet dimensions (in tablet coordinates)
    experimentDescription.setup.tablet.maxx = 25631; %43600;
    experimentDescription.setup.tablet.maxy = 14417; %32799;
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
if part<=3
    experimentDescription.setup.images = {'4targetsallsmall.png','fixation.png','blankscreen.png'};
elseif part==4
    experimentDescription.setup.images = {'reverse.png','fixation.png','blankscreen.png'};
elseif part==5
    experimentDescription.setup.images = {'scaled.png','fixation.png','blankscreen.png'};
end
fixation = 2;
blankscreen = 3;

experimentDescription.setup.beeps{1}.frequency = 1000; %Hz = frequency of the BBC pips on the hour
experimentDescription.setup.beeps{1}.duration = 0.1; %s


% if protocolType==1
%     sequence = [1 2 2 2 1];
% else
%     sequence = [1 1 1 1 1];
% end

if any(part==[1 4 5])
    numblocks = 1;
    trialsperblock = 60;
elseif part==2
    numblocks = 6;
    trialsperblock = 60; 
elseif part==3
    numblocks = 1;
    trialsperblock = 60;
end
n=0;

offsets = [0 5];

for block=1:numblocks
    n=n+1;
    experimentDescription.trial{n}.stimulus.showText.text = sprintf('%s Block %d',shortnames{part},block);
    experimentDescription.trial{n}.stimulus.showText.color = [0 0 0];
    if device==1
        experimentDescription.trial{n}.starttrial = 'stylusButton'; %'mouseClick'; %'keyboard';
    else
         experimentDescription.trial{n}.starttrial = 'keyboard';
    end
    experimentDescription.trial{n}.targetType = 'dummy';
    experimentDescription.trial{n}.recordingTime = 0;
    experimentDescription.trial{n}.recording = 0;
    experimentDescription.trial{n}.showPosition = 1;
    experimentDescription.trial{n}.backgroundColor = [255 255 255];
    
    for trialnum=1:trialsperblock
        %     n=n+1;
        %     experimentDescription.trial{n}.stimulus.showText.text = 'Ready?';
        %     experimentDescription.trial{n}.starttrial = 'dontWait';%keyboard';
        %     experimentDescription.trial{n}.targetType = 'dummy';
        %     experimentDescription.trial{n}.recordingTime = 0;
        %     experimentDescription.trial{n}.recording = 0;
        %     experimentDescription.trial{n}.showPosition = 1;
        %
        %   
        
        n=n+1;
        
        if group==2 || any(part==[1 3 4 5]) || mod(trialnum,2)==1
            experimentDescription.trial{n}.stimulus.images.stimuli = [fixation 1 10 0;
                blankscreen 11 30 0;
                1 31 130 0]; % 5 seconds
            experimentDescription.trial{n}.targetType.stoppedMoving.duration = 0.5; % End trial after stopped for 1s
            experimentDescription.trial{n}.targetType.stoppedMoving.startDistance = 0.1;
            experimentDescription.trial{n}.recordingTime = 7;
            experimentDescription.trial{n}.recording = 1;
            experimentDescription.trial{n}.filename = sprintf('%s_block%d_trial%d',shortnames{part},block,trialnum);
            experimentDescription.trial{n}.backgroundColor = [255 255 255];
        else
            experimentDescription.trial{n}.stimulus.images.stimuli = [fixation 1 10 0;
                blankscreen 11 30 0;];
            experimentDescription.trial{n}.targetType = 'dummy';
            experimentDescription.trial{n}.recordingTime = 1.5;
            experimentDescription.trial{n}.recording = 0;
            experimentDescription.trial{n}.starttrial = 'dontWait';
            experimentDescription.trial{n}.showPosition = 0;
            experimentDescription.trial{n}.backgroundColor = [255 255 255];
            
            n = n+1;
            if group==1            
                %experimentDescription.trial{n}.stimulus.dots.dotsFilename = sprintf('bouncing%d.csv',subjectNum);
                experimentDescription.trial{n}.stimulus.dots.dotsFilename = sprintf('lines%d.csv',subjectNum);
                experimentDescription.trial{n}.stimulus.dots.framesPerDot = 1;
                experimentDescription.trial{n}.stimulus.dots.type = 2; % circle
                experimentDescription.trial{n}.stimulus.dots.color = [0 0 0];
                experimentDescription.trial{n}.backgroundColor = [255 255 255];
                experimentDescription.trial{n}.recordingTime = time + 1;

            elseif group==3
                experimentDescription.trial{n}.stimulus.video.filename = 'trimmed';
                experimentDescription.trial{n}.starttrial = 'dontWait';
                experimentDescription.trial{n}.targetType = 'dummy';
                experimentDescription.trial{n}.recordingTime = 6;
                experimentDescription.trial{n}.recording = 0;
                experimentDescription.trial{n}.recordingTime = 6 + 1;
            elseif group==4
                experimentDescription.trial{n}.stimulus.video.filename = 'trimmed_slow';
                experimentDescription.trial{n}.starttrial = 'dontWait';
                experimentDescription.trial{n}.targetType = 'dummy';
                experimentDescription.trial{n}.recordingTime = 6;
                experimentDescription.trial{n}.recording = 0;
                experimentDescription.trial{n}.recordingTime = 6 + 1;
            else
                error('Shouldn''t be here');
            end

            experimentDescription.trial{n}.targetType = 'dummy';
            experimentDescription.trial{n}.recording = 0;
        end
        
        experimentDescription.trial{n}.starttrial = 'dontWait';        
        experimentDescription.trial{n}.showPosition = 0;
        
        if triggerType
            experimentDescription.trial{n}.trigger{1}.time = 0;
            experimentDescription.trial{n}.trigger{1}.type = triggerTypeString;
            experimentDescription.trial{n}.trigger{1}.value = trialnum + 16;
            for tr=1:5
                experimentDescription.trial{n}.trigger{1+tr}.type = triggerTypeString;
                experimentDescription.trial{n}.trigger{1+tr}.time = tr-0.5;
                if any(part==[1 3]) || mod(trialnum,2)==1
                    experimentDescription.trial{n}.trigger{1+tr}.value = tr+offsets(1);
                else
                    experimentDescription.trial{n}.trigger{1+tr}.value = tr+offsets(2);
                end
            end
        end
        
        
    end
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);