% GENERATEPROTOCOL - generate test protocol

function filename = generateProtocol(subject,MVC,inputdevice)

if nargin<3
    inputdevice=1; % 1 = force sensors, 2 = mouse
end

filename = ['protocols/' subject '.xml'];

if ~exist('protocols','dir')
    mkdir('protocols');
end

toprng = 0.25 * MVC; % top of the screen = 25% of MVC
%                     mv/N                     N/V
% LW39695             111.4                    8.98
% LW39696             114.9                    8.70
% LW39697             110.7                    9.03
% LW39698             107.4                    9.31
% LW39666             112.7                    8.87

% LW43893             111.7                    8.95
% LW43894             107.1                    9.34
% LW43895             115.8                    8.64
% LW43896             115.0                    8.70

% sensor1 = LW43893, sensor2 = LW43894, sensor3 = LW43895, sensor4 =LW43896

if inputdevice==1
    experimentDescription.setup.forcesensors.numchannels = 4;
    experimentDescription.setup.forcesensors.gains = [8.95 9.34 8.64 8.70];
    experimentDescription.setup.forcesensors.offsets = [0 0 0 0];
    experimentDescription.setup.forcesensors.server = 'localhost';
    experimentDescription.setup.forcesensors.port = 3016;
    experimentDescription.setup.forcesensors.showPositionType = 'image';
else
    experimentDescription.setup.mouse.server = 'localhost';
    experimentDescription.setup.mouse.port = 3003;
    experimentDescription.setup.mouse.maxx = 1366;
    experimentDescription.setup.mouse.maxy = 768;
    experimentDescription.setup.mouse.showPositionType = 'image';
end
if inputdevice == 1
    experimentDescription.setup.forcesensors.displayRangeX = zeros(4,3);
    experimentDescription.setup.forcesensors.displayRangeY = [0 -toprng 0;
        0 -toprng 0;
        0 -toprng 0;
        0 -toprng 0;];
else
    experimentDescription.setup.mouse.displayRangeX = [0 0 0 0 0];
    experimentDescription.setup.mouse.displayRangeY = [0 0 0 1 0];
end

experimentDescription.setup.images = {'guinea_pig.png','lettuce-leaf.png','Rainbow_diagram_left.png','Rainbow_diagram_right.png'};

t = 1/60:1/60:7; % time
baseline = 0.9;
position(2,1:60) = baseline;
amplitude = 0.8;
riseduration = 6;
slope = -amplitude / riseduration;
position(2,61:7*60) = (t(61:7*60) - t(61)) * slope + baseline;

stimnum = [ones(1,10) 3*ones(1,10)];
%stimnum = [3*ones(1,1)];

n=0;
for trial=1:numel(stimnum)
    n = n+1;
    experimentDescription.trial{n}.stimulus.showText.text = 'please wait . . .';
    experimentDescription.trial{n}.stimulus.showText.color = [0 0 0];
    experimentDescription.trial{n}.starttrial = 'dontWait';
    experimentDescription.trial{n}.targetType = 'dummy';
    experimentDescription.trial{n}.recordingTime = 10;
    experimentDescription.trial{n}.backgroundColor = [255 255 255];
    experimentDescription.trial{n}.filename = sprintf('warmingup%d',trial);
    if inputdevice==1        
        n = n+1;
        experimentDescription.trial{n}.stimulus.showText.text = 'Ready to zero';
        experimentDescription.trial{n}.stimulus.showText.color = [0 0 0];
        experimentDescription.trial{n}.starttrial = 'keyboard';
        experimentDescription.trial{n}.recording = 0;
        experimentDescription.trial{n}.recordingTime = 0;
        experimentDescription.trial{n}.backgroundColor = [255 255 255];
        
        n=n+1;
        experimentDescription.trial{n}.stimulus.calibrateForceSensors.calibrationType = 1; % zeroing
        experimentDescription.trial{n}.stimulus.calibrateForceSensors.calibrationSensor = [1 2 3 4]; %[1 2 3 4 5]; % [1];
        experimentDescription.trial{n}.starttrial = 'dontWait';
        experimentDescription.trial{n}.targetType = 'dummy';
        experimentDescription.trial{n}.recordingTime = 3;
        experimentDescription.trial{n}.backgroundColor = [255 255 255];
        experimentDescription.trial{n}.filename = sprintf('zeroing%d',trial);
    end
        
    n = n+1;
    experimentDescription.trial{n}.recordingTime = 8;
    experimentDescription.trial{n}.recording = 1;
    experimentDescription.trial{n}.backgroundColor = [255 255 255];
    experimentDescription.trial{n}.filename = sprintf('trial%d',trial);
    experimentDescription.trial{n}.showPosition = 3;
    if stimnum(trial)==1
        position(1,:) = 0.45; 
        if inputdevice==1
            experimentDescription.setup.forcesensors.showPositionColor{n} = [2 0 0];
            experimentDescription.setup.forcesensors.offsetX(n,1) = 0.6; % 0.55
            experimentDescription.setup.forcesensors.offsetY(n,1) = 0.9;
        else
            experimentDescription.setup.mouse.showPositionColor{n} = [2 0 0];
            experimentDescription.setup.mouse.offsetX(n,1) = 0.6; % 0.55
            experimentDescription.setup.mouse.offsetY(n,1) = 0;
        end
    else
        position(1,:) = 0.3962; 
        if inputdevice == 1
            experimentDescription.setup.forcesensors.showPositionColor{n} = [4 0 0];
            experimentDescription.setup.forcesensors.offsetX(n,1) = 0.68; %0.6038;
            experimentDescription.setup.forcesensors.offsetY(n,1) = 0.9;
        else
            experimentDescription.setup.mouse.showPositionColor{n} = [4 0 0];
            experimentDescription.setup.mouse.offsetX(n,1) = 0.68; %0.6038;
            experimentDescription.setup.mouse.offsetY(n,1) = 0;
        end
    end
    experimentDescription.trial{n}.stimulus.images.stimuli = ...
        [stimnum(trial) * ones(numel(t),1) (1:numel(t))' (1:numel(t))' zeros(numel(t),1) position'];

end
    
tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);