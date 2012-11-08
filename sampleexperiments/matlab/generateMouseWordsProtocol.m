% GENERATEMOUSEWORDSPROTOCOL - generate the protocol for the MouseWords experiment
%
% generateMouseWordsProtocol

function generateMouseWordsProtocol

filename = 'protocols/MouseWords.xml';

experimentDescription.setup.monitorWidth = 70; %cm
experimentDescription.setup.viewingDistance = 68; %cm
experimentDescription.setup.xshift = 0; % relative shift of fixation / targets

screenwidth = 1280;
screenheight = 1024;

experimentDescription.setup.mouse.server = 'localhost';
experimentDescription.setup.mouse.port = 3003;
experimentDescription.setup.mouse.maxx = screenwidth; % 1920; % screen width
experimentDescription.setup.mouse.maxy = screenheight; %1200; % screen height

targetnames = {'candle','candy','dollar','dolphin','pickle','picture','sandal','sandwich'};
for k=1:numel(targetnames)
    experimentDescription.setup.sounds{k} = [targetnames{k} '.wav'];
end

% each image is 300 x 300
imagey(1:2) = (300/2) / screenheight;
imagex(1) = (300/2) / screenwidth;
imagex(2) = 1 - (300/2) / screenwidth;

experimentDescription.setup.mouseTargets  = ...
    [0              0 imagex(1)*2 imagey(1)*2;
    1-imagex(1)*2  0 imagex(1  )*2 imagey(2)*2;
    0.45 0.9 0.1 0.1;];

experimentDescription.setup.boxes = [0.45 0.9 0.1 0.1];

experimentDescription.common.showPosition = 1; % need to show the mouse position

for k=1:numel(targetnames)
    experimentDescription.setup.images{k} = [targetnames{k} '.jpg'];
end

% target1 target2 distractor?
combos = [1 2 1
    2 1 1
    3 4 1
    4 3 1
    5 6 1
    6 5 1
    7 8 1
    8 7 1
    1 3 0
    3 1 0
    2 4 0
    4 2 0
    5 7 0
    7 5 0
    6 8 0
    8 6 0];

%fourth column is target
combos = [combos ones(16,1);
    combos 2*ones(16,1);];

neworder = randperm(size(combos,1));
combos = combos(neworder,:);

imagenum = combos(:,1:2);
distractor = combos(:,3);
target = combos(:,4);

n=0;

for t=1:numel(target)
    n = n+1;
    experimentDescription.trial{n}.starttrial.mouseClick.targets = 3;
    experimentDescription.trial{n}.targetType.mouseEntersBox.targets = [1 2];
    experimentDescription.trial{n}.recordingTime = 5;
    experimentDescription.trial{n}.waitTimeBefore = 1;
    experimentDescription.trial{n}.filename = sprintf('%d_%d_%d_%d_%d',imagenum(t,1),imagenum(t,2),target(t),distractor(t),t);
    experimentDescription.trial{n}.playAudioFile.number = combos(t,target(t));
    experimentDescription.trial{n}.playAudioFile.starttime = 0.5;
   
    experimentDescription.trial{n}.stimulus.images.stimuli = [imagenum(t,1) -inf inf 0 imagex(1) imagey(1);
                                                              imagenum(t,2) -inf inf 0 imagex(2) imagey(2)];
    experimentDescription.trial{n}.targetNum = target(t);
    experimentDescription.trial{n}.textFeedback = 1;
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);


