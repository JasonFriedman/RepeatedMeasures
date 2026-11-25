% GENERATEPROTOCOL
function generateProtocol(subjectNum,useKeyboard,useTactors)

COMport = 6; 
%COMport = 'F2M38'; % bluetooth identifier

rng('shuffle');

if useTactors
    filename = ['protocols/simonTactile' subjectNum '.xml'];
else
    filename = ['protocols/simonVisual' subjectNum '.xml'];
end

locations = [1 2]; % left / right
targetsymbol = [1 2]; % tri or continuous / square or pulsed
locationnames = {'left','right'};
symbolnames = {'tri','square'};
tactornames = {'continuous','pulsed'};

SOA = [0 150 250];

repetitions_per_block = 4;

blocks = 10; %0; 

totalrepetitions = blocks * numel(locations) * numel(targetsymbol) * numel(SOA) * repetitions_per_block; % 48 per block, 10 blocks = 480 trials

locationsblock = repmat(locations,1,repetitions_per_block*numel(targetsymbol)*numel(SOA));
targetsymbolsblock = repmat(reshape(repmat(targetsymbol,numel(locations),1),1,numel(locations)*numel(targetsymbol)),1,repetitions_per_block*numel(SOA));
SOAblock = repmat(reshape(repmat(1:numel(SOA),numel(locations)*numel(targetsymbol),1),1,numel(locations)*numel(targetsymbol)*numel(SOA)),1,repetitions_per_block);

if useKeyboard
    experimentDescription.setup.keyboard.server = 'localhost';
    experimentDescription.setup.keyboard.port = 3002;
else
    experimentDescription.setup.liberty.server = 'localhost';
    experimentDescription.setup.liberty.port = 3015;
    experimentDescription.setup.liberty.numsensors = 1;
    experimentDescription.setup.liberty.recordOrientation = 1;
end

if useTactors
    experimentDescription.setup.tactors.COMport = COMport;
    experimentDescription.setup.tactors.sinFreq1 = 250;
    experimentDescription.setup.tactors.sinFreq2 = 240;
    experimentDescription.setup.tactors.gain = 3;

    %
    
    commands = [4 5];
    parameters= {[3 0],[1 500]};
    
    % pulsed left
    %experimentDescription.setup.tactors.sequences{1}.commands = [4     1    2   3];
    %experimentDescription.setup.tactors.sequences{1}.parameters = {[3 0],1,   500,[]};
    experimentDescription.setup.tactors.sequences{1}.commands =   [4     5];
    experimentDescription.setup.tactors.sequences{1}.parameters = {[3 0],[1 500]};


    % pulsed right
    experimentDescription.setup.tactors.sequences{2}.commands =   [4     5];
    experimentDescription.setup.tactors.sequences{2}.parameters = {[3 0],[2 500]};

    % continuous left
    experimentDescription.setup.tactors.sequences{3}.commands =   [4     5];
    experimentDescription.setup.tactors.sequences{3}.parameters = {[1 0],[1 500]};

    % continuous right
    experimentDescription.setup.tactors.sequences{4}.commands =   [4     5];
    experimentDescription.setup.tactors.sequences{4}.parameters = {[1 0],[2 500]};
end

% define the beeps
    experimentDescription.setup.beeps{1}.frequency = 500;
    experimentDescription.setup.beeps{1}.duration = 0.1;

% first is the word, center the location, e.g. left_center
experimentDescription.setup.images = {'RecLeft.png','RecRight.png','TriLeft.png','TriRight.png','Fixation.png','InstTriLeft.png','InstTriRight.png','InstContLeft.png','InstContRight.png'}; % 'left_center.png','right_center.png'

experimentDescription.setup.incrementOnAbort = 1; % increment to the next trial on abort because they already get the tactile stimulation
trialnum = 0;

if ~useKeyboard
    names = {'Start position','Left target','Right target'};
    for t=1:numel(names)
        trialnum = trialnum+1;
        experimentDescription.trial{trialnum}.stimulus.showText.text = names{t};
        experimentDescription.trial{trialnum}.starttrial = 'keyboard';
        experimentDescription.trial{trialnum}.targetType.defineTarget.targetNum = t;
        experimentDescription.trial{trialnum}.recordingTime = 3;
        experimentDescription.trial{trialnum}.filename = ['targetDefinition' num2str(t)];
    end
end

subject = num2str(subjectNum);
if useTactors
    if any(mod(subject,4)==[1 2])
        instructionsNum = 8;
    else
        instructionsNum = 9;
    end
else
    if any(mod(subject,4)==[1 3])
        instructionsNum = 6;
    else
        instructionsNum = 7;
    end
end

trialnum = trialnum + 1;

experimentDescription.trial{trialnum}.stimulus.showImage.stimuli = instructionsNum;
experimentDescription.trial{trialnum}.starttrial = 'keyboard';
experimentDescription.trial{trialnum}.recordingTime = 0;
experimentDescription.trial{trialnum}.recording = 0;

for block=1:blocks
   neworder = randperm(numel(locationsblock));

   trialnum = trialnum +1;

   experimentDescription.trial{trialnum}.recordingTime = 0;
   experimentDescription.trial{trialnum}.recording = 0;
   if useKeyboard
       experimentDescription.trial{trialnum}.stimulus.showText.text = sprintf('Press space to start');
       experimentDescription.trial{trialnum}.starttrial = 'keyboard';
   else
       %experimentDescription.trial{trialnum}.stimulus.showText.text = sprintf('Press pedal to start');
       experimentDescription.trial{trialnum}.stimulus.showText.text= sprintf('Block %d of %d',block,blocks);
       experimentDescription.trial{trialnum}.starttrial = 'keyboard';
       %experimentDescription.trial{trialnum}.starttrial.pedal.joystickType = 2;
       %experimentDescription.trial{trialnum}.starttrial.pedal.joystickButton = 3;
   end
   
   for n=1:numel(neworder)
       trialnum = trialnum +1;
       symbol = targetsymbolsblock(neworder(n));
       location = locationsblock(neworder(n));
       thisSOA = SOAblock(neworder(n));

       
       if useKeyboard
           experimentDescription.trial{trialnum}.starttrial = 'dontWait';
           experimentDescription.trial{trialnum}.targetType.keyboard.keytopress = {'z','m'}; % (z for left, m for right)
           experimentDescription.trial{trialnum}.targetNum = word; % 1 = z = left, 2 = m = right
       else
           experimentDescription.trial{trialnum}.starttrial.targetInSpace.target = 1;
           experimentDescription.trial{trialnum}.starttrial.targetInSpace.threshold = 3;
           experimentDescription.trial{trialnum}.targetType.targetInSpace.targets = [2 3];
           experimentDescription.trial{trialnum}.targetType.targetInSpace.threshold = 3;
           experimentDescription.trial{trialnum}.checkMoving = 2 + SOA(thisSOA) / 1000 + 0.3; % Must start moving before SOA + 350ms
           experimentDescription.trial{trialnum}.checkMovingAfter = 2 + SOA(thisSOA) / 1000 - 0.1; % Must not start moving before SOA -100 ms
           if any(instructionsNum==[6 8])% triangle left / rectangle right
               % continuous left / pulsed right
               if symbol==2
                   experimentDescription.trial{trialnum}.targetNum = 2; % 2 = left, 3 = right
               else
                   experimentDescription.trial{trialnum}.targetNum = 3;
               end
           elseif any(instructionsNum==[7 9])% triangle right / rectangle left
               % continuous right / pulsed left
               if symbol==2
                   experimentDescription.trial{trialnum}.targetNum = 3; % 2 = left, 3 = right
               else
                   experimentDescription.trial{trialnum}.targetNum = 2;
               end
           end
       end
       if useTactors
           experimentDescription.trial{trialnum}.tactor.time = 2;
           experimentDescription.trial{trialnum}.tactor.sequenceNumber = (symbol-1) * 2 + location;
           experimentDescription.trial{trialnum}.stimulus.images.stimuli = [5 1 inf 0];
           experimentDescription.trial{trialnum}.filename = sprintf('%s_%s_%d_%d',tactornames{symbol},locationnames{location},block,n);
       else
          experimentDescription.trial{trialnum}.stimulus.images.stimuli = [5 1 120 0;
                                                                          (symbol-1) * 2 + location 121 150 0];
          experimentDescription.trial{trialnum}.filename = sprintf('%s_%s_%d_%d',symbolnames{symbol},locationnames{location},block,n);
       end
       
       experimentDescription.trial{trialnum}.beep{1}.time = 2 + SOA(thisSOA) / 1000 - 1;
       experimentDescription.trial{trialnum}.beep{1}.beepNumber = 1;
       experimentDescription.trial{trialnum}.beep{2}.time = 2 + SOA(thisSOA) / 1000 - 0.5;
       experimentDescription.trial{trialnum}.beep{2}.beepNumber = 1;
       experimentDescription.trial{trialnum}.beep{3}.time = 2 + SOA(thisSOA) / 1000;
       experimentDescription.trial{trialnum}.beep{3}.beepNumber = 1;
       
       experimentDescription.trial{trialnum}.recordingTime = 5;
       experimentDescription.trial{trialnum}.recording = 1;
   end
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);