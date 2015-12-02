% GENERATEMALEFEMALETRAKSTARPROTOCOL - generate a protocol files for the trakStar version of male/female experiment
%
% generateMaleFemaleTrakStarProtocol(recordingDevices)
% recordingDevices = 1 (default) - measure the trajectory with the
% trakStar, start the trial by placing your finger at the start location
%
% When using the trakStar, you need to define 3 locations (when the program starts)
% I usually mark them with a sticker
% 1) the left target (usually a little to the left of the monitor)
% 2) the right target (usually a little to the right of the monitor)
% 3) the start location (usually in the middle)
%
% recordingDevices = 2 - use a mouse (for testing), put the mouse in the
% lower box to start the trial

function [filename,experimentDescription] = generateMaleFemaleTrakStarProtocol(recordingDevices)

if nargin<1 || isempty(recordingDevices)
    recordingDevices = 1;
end

filename = 'protocols/MaleFemaleTrakStar.xml';

experimentDescription.setup.monitorWidth = 70; %cm
experimentDescription.setup.viewingDistance = 68; %cm
experimentDescription.setup.xshift = 0; % relative shift of fixation / targets

n=0;
if recordingDevices==1
    experimentDescription.setup.trakStar.numsensors = 1;
    experimentDescription.setup.trakStar.server = 'localhost';
    experimentDescription.setup.trakStar.port = 3019;
    
    % Define where the targets are
    names = {'Left target','Right target','Start position'};
    for t=1:numel(names)
        n = n+1;
        experimentDescription.trial{n}.stimulus.showText.text = names{t};
        experimentDescription.trial{n}.starttrial = 'keyboard';
        experimentDescription.trial{n}.targetType.defineTarget.targetNum = t;
        experimentDescription.trial{n}.recordingTime = 3;
        experimentDescription.trial{n}.filename = ['targetDefinition' num2str(t)];
    end
else
    experimentDescription.setup.mouse.server = 'localhost';
    experimentDescription.setup.mouse.port = 3003;
    experimentDescription.setup.mouse.maxx = 1920; % Adjust according to monitor resolution
    experimentDescription.setup.mouse.maxy = 1080;
    locations = ...
        [0 0.45;
        0.9 0.45;];
    boxwidth = 0.1;
    boxheight = 0.1;
    labeltexts = {'F','M'};
    for k=1:size(locations,1)
        experimentDescription.setup.labels{k}.location = locations(k,:) + [boxwidth/2 boxheight/2];
        experimentDescription.setup.labels{k}.text = labeltexts{k};
        experimentDescription.setup.labels{k}.fontSize = 16;
        experimentDescription.setup.boxes(k,:) = [locations(k,1:2) boxwidth boxheight];
        experimentDescription.setup.mouseTargets(k,:) = [locations(k,1:2) boxwidth boxheight];
    end
   experimentDescription.setup.boxes(3,:) = [0.45 0.9 0.1 0.1];
   experimentDescription.setup.mouseTargets(3,:) = [0.45 0.9 0.1 0.1];
end

experimentDescription.setup.images = {'Female1.png','Female2.png','Male1.png','Male2.png','cb.png'};

numrepetitions = 2;

targets = [repmat(1,1,numrepetitions)...
           repmat(2,1,numrepetitions)...
           repmat(3,1,numrepetitions)...
           repmat(4,1,numrepetitions)];

repetitions = zeros(1,4);
       
correct = [repmat(1,1,numrepetitions*2) repmat(2,1,numrepetitions*2)];

% randomly reorder 
neworder = randperm(numel(targets));

n=n+1;
if recordingDevices==1
    experimentDescription.trial{n}.stimulus.showText.text = {'female = left, male = right '};
else
    experimentDescription.trial{n}.stimulus.showText.text = {'F for female, M for male'};
end
experimentDescription.trial{n}.recording = 0;
experimentDescription.trial{n}.recordingTime = 2;
experimentDescription.trial{n}.starttrial = 'keyboard';

for m=1:numel(targets)
    n = n+1;
    experimentDescription.trial{n}.stimulus.images.stimuli = [targets(neworder(m)) 1 Inf 0];
    experimentDescription.trial{n}.targetNum = correct(neworder(m));
    experimentDescription.trial{n}.recordingTime = 3;
    experimentDescription.trial{n}.textFeedback = 1;
    experimentDescription.trial{n}.waitTimeBefore = 1;
    repetitions(targets(neworder(m))) = repetitions(targets(neworder(m)))+1;
    experimentDescription.trial{n}.filename = sprintf('%d_%d_R%d',correct(neworder(m)),targets(neworder(m)),repetitions(targets(neworder(m))));
    if recordingDevices==1
        experimentDescription.trial{n}.starttrial.targetInSpace.target = 3;
        experimentDescription.trial{n}.starttrial.targetInSpace.threshold = 15; % mm
        experimentDescription.trial{n}.targetType.targetInSpace.targets = [1 2];
        experimentDescription.trial{n}.targetType.targetInSpace.threshold = 15; % mm
    else
        experimentDescription.trial{n}.starttrial.mouseInBox.targets = 3;
        experimentDescription.trial{n}.showPosition = 1;
        experimentDescription.trial{n}.targetType.mouseEntersBox.targets = [1 2];
    end

end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);


