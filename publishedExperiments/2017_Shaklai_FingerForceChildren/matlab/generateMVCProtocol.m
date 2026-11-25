function generateMVCProtocol

MVC = 40;
toprng = 0.25 * MVC; % top of the screen = 30% of MVC

filename = 'protocols/MVC.xml';

% The gains of the sensors are (from the calibration certificates):
%
% serial #         Sensitivity (mv/N)         gain (N / V)
% LW36907             2.319                    431.22
% LW36908             2.285                    437.64
% LW36910             2.272                    440.14
% LW36770             2.271                    440.33
% LW36771             2.221                    450.25

% LW39695             111.4                    8.98
% LW39696             114.9                    8.70
% LW39697             110.7                    9.03
% LW39698             107.4                    9.31
% LW39666             112.7                    8.87

% sensor1 = LW39697, sensor2 = LW39666

experimentDescription.setup.forcesensors.numchannels = 4;
experimentDescription.setup.forcesensors.gains = [9.03 9.31 8.70 8.98];
experimentDescription.setup.forcesensors.offsets = [0 0 0 0];
experimentDescription.setup.forcesensors.server = 'localhost';
experimentDescription.setup.forcesensors.port = 3016;

    experimentDescription.setup.forcesensors.displayRangeX = zeros(4,3);
    experimentDescription.setup.forcesensors.displayRangeY = [0 toprng 0; 0 toprng 0; 0 toprng 0; 0 toprng 0];
    experimentDescription.setup.forcesensors.showPositionColor = [0 255 0];
    numtrials = 3;

n=0;
for trialnum=1:numtrials
    n = n+1;
    experimentDescription.trial{n}.stimulus.showText.text = 'please wait . . .';
    experimentDescription.trial{n}.starttrial = 'dontWait';
    experimentDescription.trial{n}.targetType = 'dummy';
    experimentDescription.trial{n}.recordingTime = 10;
    experimentDescription.trial{n}.filename = sprintf('warmingup%d',trialnum);
    
    n = n+1;
    experimentDescription.trial{n}.stimulus.showText.text = 'Ready to zero';
    experimentDescription.trial{n}.starttrial = 'keyboard';
    experimentDescription.trial{n}.recording = 0;
    experimentDescription.trial{n}.recordingTime = 0;
    
    n=n+1;
    experimentDescription.trial{n}.stimulus.calibrateForceSensors.calibrationType = 1; % zeroing
    experimentDescription.trial{n}.stimulus.calibrateForceSensors.calibrationSensor = [1 2 3 4]; %[1 2 3 4 5]; % [1];
    experimentDescription.trial{n}.starttrial = 'dontWait';
    experimentDescription.trial{n}.targetType = 'dummy';
    experimentDescription.trial{n}.recordingTime = 3;
    experimentDescription.trial{n}.filename = sprintf('zeroing%d',trialnum);
    
    n = n+1;
    experimentDescription.trial{n}.starttrial = 'dontWait';
    experimentDescription.trial{n}.targetType = 'dummy';
    experimentDescription.trial{n}.filename = ['trial' num2str(trialnum)'];
    experimentDescription.trial{n}.stimulus.showText.text = 'Produce maximum force';
    experimentDescription.trial{n}.recordingTime = 7; %5;
    experimentDescription.trial{n}.beep{1}.time = 1;
    experimentDescription.trial{n}.beep{2}.time = 6; %4;
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);