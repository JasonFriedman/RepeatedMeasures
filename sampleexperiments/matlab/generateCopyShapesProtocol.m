% GENERATECOPYSHAPESPROTOCOL - generate the protocol for the CopyShapes experiment
%
% generateCopyShapesProtocol(inputDevice,shortVersion)
%
% inputDevice = 1 -> use a Wacom tablet
% inputDevice = 2 -> use a mouse (for testing without a tablet present)

function generateCopyShapesProtocol(inputDevice,shortVersion)

if nargin<1 || isempty(inputDevice)
    inputDevice = 1;
end
if nargin<2 || isempty(shortVersion)
    shortVersion=1;
end

filename = 'protocols/CopyShapes.xml';

experimentDescription.setup.monitorWidth = 43.2; %cm
experimentDescription.setup.viewingDistance = 40; %cm
experimentDescription.setup.xshift = 0; % relative shift of fixation / targets

screenwidth = 1280;
screenheight = 1024;

if inputDevice==1
    experimentDescription.setup.tablet.server = 'localhost';
    experimentDescription.setup.tablet.port = 3009;
    % tablet dimensions (in tablet coordinates)
    experimentDescription.setup.tablet.maxx = 43600;
    experimentDescription.setup.tablet.maxy = 32799;
else
    experimentDescription.setup.mouse.server = 'localhost';
    experimentDescription.setup.mouse.port = 3003;
    experimentDescription.setup.mouse.maxx = screenwidth; % 1920; % screen width
    experimentDescription.setup.mouse.maxy = screenheight; %1200; % screen height
end

experimentDescription.setup.images = {
    'spiral.png',... %1
    'spiral-nocurve.png',... %2
    'spiral-nocurve-jumpdown.png',... %3
    'spiral-nocurve-jumpright.png', ... %4
    'oval.png',... %5
    'oval-nocurve.png',... %6
    'oval-nocurve-jumpdown.png',... %7
    'oval-nocurve-jumpright.png',... %8
    'line.png',... %9
    'line-nocurve.png',... %10
    'line-nocurve-jumpdown.png',... %11
    'line-nocurve-jumpright.png',... %12
    'centerdot.png',...%13
    'updot.png',...%14
    'downdot.png',...%15
    'instructions-spiral.png',... %16
    'instructions-spiral-no.png',... %17
    'instructions-oval.png',... %18
    'instructions-oval-no.png',... %19
    'instructions-line.png',... %20
    'instructions-line-no.png',... %21
    'instructions-RT.png'}; %22

% Stimuli type:
% first column is stimlus type (1=spiral, 2=curve, 3=line,4=dot)
% second column is whether the curve is visibles (1=curve visible, 2=curve invisible)
% third column is what happens to the end point (1=nothing, 2=jump down, 3 = jump right, 4 = jump up)

targets = [1 2 3];
b=0;

recordingTime = 4; % seconds
viewingTime = 4; % seconds
numblocks = 8;
lastframe = viewingTime * 60; % 5 secs at 60 Hz
switchframe = -0.2 * 60; % switch at 200ms after movement onset(12 frames)
switchframe2 = -0.4 * 60; % switch at 400ms after movement onset (24 frames) - for the RT block
if inputDevice==1
    starttrial.pedal.joystickType = 2;
    starttrial.pedal.joystickButton = 8;
    blockend_starttrial = 'stylusButton';
else
    starttrial = 'mouseClick';
    blockend_starttrial = 'keyboard';
end


for target=targets
    if target==1
        instructions1 = 16;
        instructions2 = 17;
        stimuliNum=1;
    elseif target==2
        instructions1 = 18;
        instructions2 = 19;
        stimuliNum = 2;
    elseif target==3
        instructions1 = 20;
        instructions2 = 21;
        stimuliNum = 3;
    end

    % first run a short version, then a long one
    % (or just the short version for testing)
    if shortVersion
        versions = 1;
    else
        versions = [1 0];
    end
    for short = versions
        b = b+1;
        if short==1
            l = [10 1];
            l_nocurve = [4 1];
            l_down = [2 1];
            l_right = [2 1];
            l_reminder = 0;
            l2 = [8 1];
        else
            l = [20 1];
            l_nocurve = [40 1];
            l_down = [20 1];
            l_right = [20 1];
            l_reminder = 7;
            l2 = [87 1];
            l2_regular = 80;
            %b = target*4-2;
        end
        % first part is showing the curve
        recordingTimes = recordingTime * ones(l);
        clear stimuli;clear stimuliType;
        for k=1:l(1)
            stimuli{k} = [(target-1)*4 + 1,1,lastframe,0];
            stimuliType(k,:) = [stimuliNum 1 1];
        end
        block = b * ones(l);
        blockoffset = 0;
        movementOnsetType = NaN * ones(l);
        % Instructions
        experimentDescription = writeShowImage(experimentDescription,instructions1,blockend_starttrial);
        % Trial
        experimentDescription = writeTrials(experimentDescription,l(1),recordingTimes,block,stimuli,stimuliType,starttrial,blockoffset,movementOnsetType);

        % second part the curve is invisible, and:
        % 50% is static
        % 25% jumps down
        % 25% jumps right
        % jump occurs 200ms after movement onset
        %
        % After every 10 trials, include a "reminder" trial (copy the shape)
        blockoffset = l(1)+blockoffset;
        clear stimuli;clear stimuliType;
        count = 0;
        for k=1:l_nocurve(1)
            count = count+1;
            stimuli{count} = [(target-1)*4 + 2,1,lastframe,0;];
            stimuliType(count,:) = [stimuliNum 2 1];
        end
        for k=1:l_down(1)
            count = count+1;
            stimuli{count} = [(target-1)*4 + 2,1,            switchframe,0;
                (target-1)*4 + 3,switchframe-1,inf,        0;];
            stimuliType(count,:) = [stimuliNum 2 2];
        end
        for k=1:l_right(1)
            count = count+1;
            stimuli{count} = [(target-1)*4 + 2,1,            switchframe,0;
                (target-1)*4 + 4,switchframe-1,inf,        0;];
            stimuliType(count,:) = [stimuliNum 2 3];
        end
        for k=1:l_reminder
            count = count+1;
            stimuli{count} = [(target-1)*4 + 1,1,lastframe,0;];
            stimuliType(count,:) = [stimuliNum 1 1];
        end

        block = b*ones(l2);
        recordingTimes = recordingTime * ones(l2);
        movementOnsetType = ones(l2);

        experimentDescription = writeShowImage(experimentDescription,instructions2,blockend_starttrial);
        if l_reminder==0
            experimentDescription = writeTrials(experimentDescription,l2(1),recordingTimes,block,stimuli,stimuliType,starttrial,blockoffset,movementOnsetType);
        else
            experimentDescription = writeTrialsTenth(experimentDescription,l2_regular,recordingTimes,block,stimuli,stimuliType,starttrial,blockoffset,movementOnsetType);
        end
        if  b ~= numblocks
            experimentDescription = writeMessage(experimentDescription,'End of block - take a break.',blockend_starttrial);
        else
            experimentDescription = writeMessage(experimentDescription,'End of experiment.',blockend_starttrial);
        end

    end
    % Do the "RT" blocks in the middle
    if target==targets(1) & ~shortVersion
        for short = [1 0]
            if short==1
                l = [8 1];
                l_nojump = [4 1];
                l_up = [2 1];
                l_down = [2 1];
                b = 3;
            else
                l = [80 1];
                l_nojump = [40 1];
                l_up = [20 1];
                l_down = [20 1];
                b = 4;
            end
            count = 0;
            clear stimuli;
            clear stimuliType;
            for k=1:l_nojump(1)
                count = count+1;
                stimuli{count} = [13,1,lastframe,0;];
                stimuliType(count,:) = [4 1 1];
            end
            for k=1:l_up(1)
                count = count+1;
                stimuli{count} = [13,1,            switchframe2,0;
                    14,switchframe2-1,inf,        0;];
                stimuliType(count,:) = [4 1 4];
            end
            for k=1:l_down(1)
                count = count+1;
                stimuli{count} = [ 13,1,            switchframe2,0;
                    15,switchframe2-1,inf,        0;];
                stimuliType(count,:) = [4 1 2];
            end

            recordingTimes = recordingTime * ones(l);
            block = b*ones(l);
            blockoffset = 0;

            experimentDescription = writeShowImage(experimentDescription,22,blockend_starttrial);
            experimentDescription = writeTrials(experimentDescription,l(1),recordingTimes,block,stimuli,stimuliType,starttrial,blockoffset,movementOnsetType);
            experimentDescription = writeMessage(experimentDescription,'End of block - take a break.',blockend_starttrial);
        end
    end
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);

%% --------------------------------------------------------------------------------------------------------------------
% Write the trials, but every 10th, put in an "reminder" trial
function experimentDescription = writeTrialsTenth(experimentDescription,counter,recordingTime,block,stimuli,stimuliType,starttrial,blockoffset,movementOnsetType)

if isfield(experimentDescription,'trial')
    offset = length(experimentDescription.trial);
else
    offset = 0;
end

neworder = randperm(counter);
for m=(length(neworder)/10)-1:-1:1
    neworder = [neworder(1:m*10) counter+m neworder(m*10+1:end)];
end

for k=1:length(neworder)
    experimentDescription.trial{offset+k}.stimulus.images.stimuli = stimuli{neworder(k)};
    experimentDescription.trial{offset+k}.starttrial = starttrial;
    experimentDescription.trial{offset+k}.showPosition = 1;
    experimentDescription.trial{offset+k}.recordingTime= recordingTime(neworder(k));
    if ~isnan(movementOnsetType(k)) && any(stimuli{neworder(k)}(:)<0)
        experimentDescription.trial{offset+k}.movementonset.type = movementOnsetType(k);
    end
    experimentDescription.trial{offset+k}.filename = sprintf('%d_%d_%d_%d_%d',...
        block(neworder(k)),...
        k+blockoffset,...
        stimuliType(neworder(k),1),...
        stimuliType(neworder(k),2),...
        stimuliType(neworder(k),3));
end


%% --------------------------------------------------------------------------------------------------------------------
function experimentDescription = writeTrials(experimentDescription,counter,recordingTime,block,stimuli,stimuliType,starttrial,blockoffset,movementOnsetType)

if isfield(experimentDescription,'trial')
    offset = length(experimentDescription.trial);
else
    offset = 0;
end
neworder = randperm(counter);

for k=1:counter
    experimentDescription.trial{offset+k}.stimulus.images.stimuli = stimuli{neworder(k)};
    experimentDescription.trial{offset+k}.starttrial = starttrial;
    experimentDescription.trial{offset+k}.showPosition = 1;
    experimentDescription.trial{offset+k}.recordingTime= recordingTime(neworder(k));
    if ~isnan(movementOnsetType(k)) && any(stimuli{neworder(k)}(:)<0)
        experimentDescription.trial{offset+k}.movementonset.type = movementOnsetType(k);
    end
    experimentDescription.trial{offset+k}.filename = sprintf('%d_%d_%d_%d_%d',...
        block(neworder(k)),...
        k + blockoffset,...
        stimuliType(neworder(k),1),...
        stimuliType(neworder(k),2),...
        stimuliType(neworder(k),3));
end



%% ---------------------------------------------------------------------------------------------
function experimentDescription = writeShowImage(experimentDescription,imageNum,starttrial)

if isfield(experimentDescription,'trial')
    offset = length(experimentDescription.trial);
else
    offset = 0;
end
experimentDescription.trial{offset+1}.stimulus.showImage.stimuli = imageNum;
experimentDescription.trial{offset+1}.recordingTime = 0;

experimentDescription.trial{offset+1}.starttrial = starttrial;

%% ------------------------------------------------------------------------
function experimentDescription = writeMessage(experimentDescription,descriptionText,starttrial)

if isfield(experimentDescription,'trial')
    offset = length(experimentDescription.trial);
else
    offset = 0;
end
experimentDescription.trial{offset+1}.stimulus.showText.text = descriptionText;
experimentDescription.trial{offset+1}.recordingTime = 0;
experimentDescription.trial{offset+1}.recording = 0;

experimentDescription.trial{offset+1}.starttrial = starttrial;