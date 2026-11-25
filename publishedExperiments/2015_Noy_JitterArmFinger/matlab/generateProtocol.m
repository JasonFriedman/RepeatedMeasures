% GENERATEPROTOCOL - generate protocol for a sample experiment with force sensors
% generateProtocol(protocolType,MVC,subject,inputDevice)
%
% protocolType: 
%  1: Circles
%  2: ForceRamp
%  3: ForceRampTogether
%  4: copyCircles
%  5: copyRectangles
%  6: Rectangles
%  7: MVC
%
% subject should be a string
% inputDevice: 1 = force sensors, 2 = mouse, 
% 3 = tablet, 4 = liberty 
% (inputDevice 2/3/4 only works for protocol 5)

function generateProtocol(protocolType,MVC,subject,inputDevice)

if ~exist('protocols','dir')
    mkdir('protocols');
end

if nargin<2 || isempty(MVC)
    MVC = 40;
end

if nargin<3
    subject = '';
end

if isnumeric(subject)
    subject = num2str(subject);
end

if nargin<4
    inputDevice = 1; % force sensors
end

inputDeviceName = {'','Mouse','Tablet','Liberty'};

toprng = 0.2 * MVC; % top of the screen = 20% of MVC

if protocolType==1
    filenameStart = 'Circles';
elseif protocolType==2
    filenameStart = 'ForceRamp';
elseif protocolType==3
    filenameStart = 'ForceRampTogether';
elseif protocolType==4
    filenameStart = 'copyCircles';
elseif protocolType==5
    filenameStart = 'copyRectangles';
elseif protocolType==6
    filenameStart = 'Rectangles';
elseif protocolType==7
    filenameStart = 'MVC';
end

filename = ['protocols/' filenameStart inputDeviceName{inputDevice} subject '.xml'];

%experimentDescription.setup.monitorWidth = 70; %cm
%experimentDescription.setup.viewingDistance = 68; %cm
%experimentDescription.setup.xshift = 0; % relative shift of fixation / targets

% The gains of the sensors are (from the calibration certificates):
%
% serial #         Sensitivity (mv/N)         gain (N / V)
% LW36907             2.319                    431.22
% LW36908             2.285                    437.64
% LW36910             2.272                    440.14
% LW36770             2.271                    440.33
% LW36771             2.221                    450.25

numtrials = 5;
n=0;

% sensor1 = LW36770, sensor2 = LW36907
if inputDevice==1 % force sensors
    experimentDescription.setup.forcesensors.numchannels = 1; %5;
    experimentDescription.setup.forcesensors.gains =   [440.33]; % 431.22]; % [1 1 1 1 1];
    experimentDescription.setup.forcesensors.offsets = [0]; %      0]; % [0 0 0 0 0];
    experimentDescription.setup.forcesensors.server = 'localhost';
    experimentDescription.setup.forcesensors.port = 3016;
    experimentDescription.setup.forcesensors.showPositionColor = [0 255 0];%;255 0 0];
    
    if protocolType==1
        experimentDescription.setup.forcesensors.displayRangeX = [0 0 0; 0 0 0]; % [0 0 1/3];
        experimentDescription.setup.forcesensors.displayRangeY = [0 toprng 0; 0 toprng 0];
        experimentDescription.setup.forcesensors.showPositionColor = [0 255 0;255 0 0];
    elseif protocolType==2 || protocolType==3
        if protocolType==2
            experimentDescription.setup.forcesensors.showPositionColor = [0 255 0;255 0 0];
            experimentDescription.setup.forcesensors.displayRangeX = [0 0 1/6; 0 0 1/6]; % [0 0 1/3];
        else
            experimentDescription.setup.forcesensors.showPositionColor = [255 0 0;];
            experimentDescription.setup.forcesensors.displayRangeX = [0 0 1/6; 0 0 0]; % [0 0 1/3];
            toprng = toprng / 2;
        end
        experimentDescription.setup.forcesensors.displayRangeY = [0 -toprng/2 0; 0 -toprng/2 0];
        experimentDescription.setup.forcesensors.offsetY = 0.9;
    elseif protocolType==4
        experimentDescription.setup.forcesensors.displayRangeX = [0 0 0; 0 0 0]; % [0 0 1/3];
        experimentDescription.setup.forcesensors.displayRangeY = [0 toprng 0; 0 0 0];
        experimentDescription.setup.forcesensors.showPositionColor = [0 255 0;255 0 0];
    elseif protocolType==5
        experimentDescription.setup.forcesensors.displayRangeX = [0 0 0]; % [0 0 1/3];
        experimentDescription.setup.forcesensors.displayRangeY = [toprng*0.2 toprng 0];
        experimentDescription.setup.forcesensors.showPositionColor = [0 255 0];
        experimentDescription.setup.forcesensors.filterType = 'butter';
        experimentDescription.setup.forcesensors.filterOrder = 4;
        experimentDescription.setup.forcesensors.filterCutoff = 8; %[0.01 8]; % 8; % Hz
        experimentDescription.setup.forcesensors.samplerate = 180; % Hz
        n = n+1;
        experimentDescription.trial{n}.stimulus.showText.text = 'Warming up . . . please wait';
        experimentDescription.trial{n}.starttrial = 'dontWait';
        experimentDescription.trial{n}.recording = 0;
        experimentDescription.trial{n}.recordingTime = 60;

    elseif protocolType==6
        experimentDescription.setup.forcesensors.displayRangeX = [0 0 0; 0 0 0]; % [0 0 1/3];
        experimentDescription.setup.forcesensors.displayRangeY = [0 toprng 0; 0 toprng 0];
        experimentDescription.setup.forcesensors.showPositionColor = [0 0 255;255 0 0];
    end
elseif inputDevice==2
    experimentDescription.setup.mouse.server = 'localhost';
    experimentDescription.setup.mouse.port = 3003;
    experimentDescription.setup.mouse.maxx = 1920;
    experimentDescription.setup.mouse.maxy = 1080;
    experimentDescription.setup.mouse.showPositionType = 'rectangle';
    experimentDescription.setup.mouse.showPositionColor = [0 0 255];
elseif inputDevice==3
    experimentDescription.setup.tablet.server = 'localhost';
    experimentDescription.setup.tablet.port = 3009;
    experimentDescription.setup.tablet.maxx = 43600;
    experimentDescription.setup.tablet.maxy = 32799;
    experimentDescription.setup.tablet.showPositionType = 'rectangle';
    experimentDescription.setup.tablet.showPositionColor = [0 255 0];
elseif inputDevice==4
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

if protocolType==2 || protocolType==3
    experimentDescription.setup.images = 'ramp.jpg';
elseif protocolType==5
    numtrials = 11;
    experimentDescription.setup.sounds{1} = 'gong.wav';
    order = [9:11 randperm(8)];
elseif protocolType==7
    numtrials = 3;
end

% for trialnum=1:2
%     n = n+1;
%     experimentDescription.trial{n}.stimulus.showText.text = 'press sensors';
%     experimentDescription.trial{n}.starttrial = 'dontWait';
%     experimentDescription.trial{n}.targetType = 'dummy';
%     experimentDescription.trial{n}.recordingTime = 3;
%     experimentDescription.trial{n}.filename = ['trial' num2str(trialnum)'];
%     experimentDescription.trial{n}.showPosition = 1;
% end



for trialnum=1:numtrials
        if inputDevice==1

            n = n+1;
            experimentDescription.trial{n}.stimulus.showText.text = 'please wait . . .';
            experimentDescription.trial{n}.starttrial = 'dontWait';
            experimentDescription.trial{n}.targetType = 'dummy';
            experimentDescription.trial{n}.recordingTime = 5;
            experimentDescription.trial{n}.filename = 'warmingup';
            
            n = n+1;
            experimentDescription.trial{n}.stimulus.showText.text = 'Ready to zero';
            experimentDescription.trial{n}.starttrial = 'keyboard';
            experimentDescription.trial{n}.recording = 0;
            experimentDescription.trial{n}.recordingTime = 0;
            
            n = n+1;
            experimentDescription.trial{n}.stimulus.showText.text = 'please wait . . .';
            experimentDescription.trial{n}.starttrial = 'dontWait';
            experimentDescription.trial{n}.targetType = 'dummy';
            experimentDescription.trial{n}.recordingTime = 5;
            experimentDescription.trial{n}.filename = 'warmingup';
            
            n=n+1;
            experimentDescription.trial{n}.stimulus.calibrateForceSensors.calibrationType = 1; % zeroing
            experimentDescription.trial{n}.stimulus.calibrateForceSensors.calibrationSensor = 1; %[1 2]; % [1];
            experimentDescription.trial{n}.starttrial = 'dontWait';
            experimentDescription.trial{n}.targetType = 'dummy';
            experimentDescription.trial{n}.recordingTime = 3;
            experimentDescription.trial{n}.filename = 'zeroing';
        end
    
    n = n+1;
    experimentDescription.trial{n}.starttrial = 'dontWait';
    experimentDescription.trial{n}.targetType = 'dummy';
    experimentDescription.trial{n}.filename = sprintf('trial%d',trialnum);
    if protocolType==1
        experimentDescription.trial{n}.stimulus = 'none'; %.showText.text = 'press sensors';
        experimentDescription.trial{n}.recordingTime = 30;
        experimentDescription.trial{n}.showPosition = 4;
    elseif protocolType==2 || protocolType==3
        experimentDescription.trial{n}.stimulus.images.stimuli = [1 0 inf 0];
        experimentDescription.trial{n}.recordingTime = 10;
        if protocolType==2
            experimentDescription.trial{n}.showPosition = 2;
        else
            experimentDescription.trial{n}.showPosition = 1;
        end
    elseif protocolType==4
        experimentDescription.trial{n}.stimulus.circle.circlesFilename = 'circles.csv';
        experimentDescription.trial{n}.stimulus.circle.framesPerCircle = 1;
        experimentDescription.trial{n}.stimulus.circle.color = [255 0 0];
        experimentDescription.trial{n}.recordingTime = 30;
        experimentDescription.trial{n}.showPosition = 4;
    elseif protocolType==5
        experimentDescription.trial{n}.stimulus.rectangle.rectanglesFilename = sprintf('rectangles%d.csv',order(trialnum));
        experimentDescription.trial{n}.stimulus.rectangle.framesPerRectangle = 1;
        experimentDescription.trial{n}.stimulus.rectangle.color = [255 0 0];
        %experimentDescription.trial{n}.waitTimeBefore = 60;
        experimentDescription.trial{n}.recordingTime = 60;
        if inputDevice==4 % liberty
            experimentDescription.trial{n}.showPosition = 1;
        else
            experimentDescription.trial{n}.showPosition = 5;
        end
        % The gong sounds after 1 s
        experimentDescription.trial{n}.playAudioFile.number = 1;
        experimentDescription.trial{n}.playAudioFile.starttime = 0;
        
        if trialnum < numtrials
            if inputDevice == 3
                n = n+1;
                experimentDescription.trial{n}.stimulus.showText.text = 'Lift the pen';
                experimentDescription.trial{n}.recordingTime = 10;
                experimentDescription.trial{n}.recording = 0;
                experimentDescription.trial{n}.starttrial = 'dontWait';
            end
        end
        
    elseif protocolType==6
        experimentDescription.trial{n}.stimulus = 'none';
        experimentDescription.trial{n}.recordingTime = 30;
        experimentDescription.trial{n}.showPosition = 6;
    elseif protocolType==7
        experimentDescription.trial{n}.stimulus.showText.text = 'Produce maximum force';
        experimentDescription.trial{n}.recordingTime = 5;
        experimentDescription.trial{n}.beep{1}.time = 1;
        experimentDescription.trial{n}.beep{2}.time = 4;
    end
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);
fprintf('Successfully generated %s\n', filename);