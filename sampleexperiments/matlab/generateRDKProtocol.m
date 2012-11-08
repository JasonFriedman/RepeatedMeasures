% GENERATERDKPROTOCOL - generate a protocol files for the RDK experiment
%
% generateRDKProtocol(recordingDevices)
% recordingDevices = 1 (default) - measure the trajectory with the
% optotrak, start the trial by pressing a button (connected to a DAQ card)
%
% recordingDevices = 2 - use a mouse

function generateRDKProtocol(recordingDevices)

if nargin<1 || isempty(recordingDevices)
    recordingDevices = 1;
end

filename = 'protocols/RDK.xml';

experimentDescription.setup.monitorWidth = 70; %cm
experimentDescription.setup.viewingDistance = 68; %cm
experimentDescription.setup.xshift = 0; % relative shift of fixation / targets

if recordingDevices==1
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
    
    experimentDescription.setup.MCtrigger = 1; % will use a button box to start the trials
else
    experimentDescription.setup.mouse.server = 'localhost';
    experimentDescription.setup.mouse.port = 3003;
    experimentDescription.setup.mouse.maxx = 1280;
    experimentDescription.setup.mouse.maxy = 1024;
end

locations = ...
    [0 0.45;
    0.9 0.45;];
boxwidth = 0.1;
boxheight = 0.1;
labeltexts = {'L','R'};

for k=1:size(locations,1)
    experimentDescription.setup.labels{k}.location = locations(k,:) + [boxwidth/2 boxheight/2];
    experimentDescription.setup.labels{k}.text = labeltexts{k};
    experimentDescription.setup.labels{k}.fontSize = 16;
    experimentDescription.setup.boxes(k,:) = [locations(k,1:2) boxwidth boxheight];
    experimentDescription.setup.mouseTargets(k,:) = [locations(k,1:2) boxwidth boxheight];
end

if recordingDevices==2
   experimentDescription.setup.boxes(3,:) = [0.5 0.9 0.1 0.1];
   experimentDescription.setup.mouseTargets(3,:) = [0.5 0.9 0.1 0.1];
end

stimulus.VCRDM.percentCoherent = 50;
stimulus.VCRDM.direction = 1;
stimulus.VCRDM.numFrames = 20;
stimulus.VCRDM.speed = 5;

numrepetitions = 1;

n=0;
for k=1:numrepetitions
    n = n+1;
    experimentDescription.trial{n}.waitTimeBefore = 1;
    experimentDescription.trial{n}.stimulus = stimulus;
    if recordingDevices==1
        experimentDescription.trial{n}.starttrial = 'button';
        experimentDescription.trial{n}.targetType = 'targetOnScreen';
    else
        experimentDescription.trial{n}.starttrial.mouseEntersBox.targets = 3;
        experimentDescription.trial{n}.showPosition = 1;
        experimentDescription.trial{n}.targetType.mouseEntersBox.targets = [1 2];
    end
    
    experimentDescription.trial{n}.recordingTime = 3;
    experimentDescription.trial{n}.filename = ['file' num2str(k)];
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);


