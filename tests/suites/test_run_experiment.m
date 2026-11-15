% TEST_RUN_EXPERIMENT - run whole experiments with simulated devices and a simulated
% Psychtoolbox (virtual clock, scripted key presses and mouse movements).
% Nothing is shown on the screen and no hardware is needed.
function cases = test_run_experiment
cases = [];
cases = rmtestCase(cases,'keyboard experiment: start, respond, feedback, files',@keyboardExperiment);
cases = rmtestCase(cases,'keyboard experiment: no response is a timeout',@keyboardTimeout);
cases = rmtestCase(cases,'mouse experiment: moving into a box ends the trial',@mouseExperiment);
cases = rmtestCase(cases,'simulated device: data files, markers, beeps and triggers',@simulatedDevice);
cases = rmtestCase(cases,'q quits the experiment and the results are still saved',@quitting);
cases = rmtestCase(cases,'keyboard and mouse servers: direct client / server session',@clientServer);

function needsSimulation(info)
if ~info.simulatedPsychtoolbox || ~info.simulatedDevices
    rmtestSkip('needs the simulated Psychtoolbox and devices (use runAllTests(''simulated''))');
end

function [r,e] = runProtocol(d,name)
save(struct2xml(d),['protocols/' name '.xml']);
e = experiment(['protocols/' name '.xml'],['results/' name]);
validate(e);
e = setupdevices(e);
r = runexperiment(e,[],0);

function keys = script(varargin)
% script('space',[0.2 0.4],2,...) : key, [tDown tUp] within each period, period
keys = zeros(0,4);
for k=1:3:nargin
    keys(end+1,:) = [varargin{k+1} KbName(varargin{k}) varargin{k+2}]; %#ok<AGROW>
end

function d = keyboardProtocol
d.setup.keyboard.server = 'localhost';
d.setup.keyboard.port = 3002;
d.setup.images = {'Female1.png','Male1.png'};
d.common.starttrial = 'keyboard';
d.trial{1}.stimulus.showText.text = 'z for female, m for male';
d.trial{1}.recordingTime = 0;
d.trial{1}.recording = 0;
correct = [1 2 2 1];
for k=1:4
    d.trial{k+1}.stimulus.images.stimuli = [correct(k) 1 Inf 0];
    d.trial{k+1}.targetType.keyboard.keytopress = {'z','m'};
    d.trial{k+1}.targetNum = correct(k);
    d.trial{k+1}.recordingTime = 3;
    d.trial{k+1}.filename = sprintf('trial%d',k);
end

function keyboardExperiment(info) %#ok<*DEFNU>
needsSimulation(info);
[workDir,oldDir] = rmtestWorkDir();
try
    rmtestStartServer(keyboardserver(3002,1000,0),3002);
    w = rmtestWorld;
    % every 6 seconds: space starts the trial, then 'z' is pressed 2 s later
    w.keyScript = script('space',[0.5 1.0],6,'z',[3.0 3.3],6);
    rmtestWorld(w);
    r = runProtocol(keyboardProtocol,'keyboard');
    w = rmtestWorld;
    files = dir('results/keyboard/kb_trial*.csv');
    data = load('results/keyboard/kb_trial1.csv');
    haveResults = exist('results/keyboard/results.mat','file');
    logtxt = fileread('results/keyboard/logfile.txt');
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);
rmtestAssert('equal',numel(r.thistrial),5,'all 5 trials should be in the results');
successful = cellfun(@(t) t.successful,r.thistrial(2:5));
rmtestAssert('equal',successful,[1 0 0 1],'z is correct for trials 1 and 4 only');
rmtestAssert(all(cellfun(@(t) t.hitTarget,r.thistrial(2:5))==1),'z (target 1) was pressed in every trial');
RTs = r.experimentdata.RTs(2:5);
rmtestAssert(all(RTs>1 & RTs<3),'reaction times should be about 2 s, got %s',mat2str(RTs,3));
rmtestAssert(isfield(r.thistrial{2},'RT'),'the RT should be stored with the trial');
rmtestAssert('equal',numel(files),4,'one data file per recorded trial');
codes = messagecodes;
rmtestAssert(any(data(:,end)==codes.firstFrame),'the first frame should be marked in the data file');
rmtestAssert(any(data(:,2)==KbName('z')),'the key press should be in the data file');
rmtestAssert(haveResults~=0,'results.mat should be written');
rmtestAssert(~isempty(strfind(logtxt,'Trial 5')),'the log file should mention every trial'); %#ok<STREMP>
rmtestAssert(any(strcmp(w.texts,'z for female, m for male')),'the instructions should be drawn');
rmtestAssert(any(strcmp(w.texts,'Success')) && any(strcmp(w.texts,'Incorrect')),'feedback should be drawn');
rmtestAssert(w.calls.CloseAll>=1,'the screen should be closed at the end');

function keyboardTimeout(info)
needsSimulation(info);
[workDir,oldDir] = rmtestWorkDir();
try
    rmtestStartServer(keyboardserver(3002,1000,0),3002);
    w = rmtestWorld;
    w.keyScript = script('space',[0.5 1.0],6); % starts the trials but never answers
    rmtestWorld(w);
    d = keyboardProtocol;
    d.trial = d.trial(1:2);
    r = runProtocol(d,'timeout');
    w = rmtestWorld;
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);
rmtestAssert('equal',r.thistrial{2}.successful,-4,'no key press should be reported as too slow');
rmtestAssert(any(strcmp(w.texts,'Too slow!!!')),'the too slow feedback should be drawn');

function mouseExperiment(info)
needsSimulation(info);
[workDir,oldDir] = rmtestWorkDir();
try
    rmtestStartServer(mouseserver(3003,1000,0),3003);
    w = rmtestWorld;
    % the mouse starts at the bottom centre and moves into the top left corner after 2 s
    w.mouseScript = [0 640 700 0; 2 640 700 0; 3 50 50 0; 100 50 50 0];
    rmtestWorld(w);
    d.setup.mouse.server = 'localhost';
    d.setup.mouse.port = 3003;
    d.setup.mouse.maxx = 1280;
    d.setup.mouse.maxy = 720;
    d.setup.mouseTargets = [0 0 0.2 0.2; 0.8 0 0.2 0.2; 0.45 0.9 0.1 0.1];
    d.setup.boxes = [0.45 0.9 0.1 0.1];
    d.trial{1}.stimulus.showText.text = 'Move to the left box';
    d.trial{1}.starttrial.mouseInBox.targets = 3;
    d.trial{1}.targetType.mouseEntersBox.targets = [1 2];
    d.trial{1}.targetNum = 1;
    d.trial{1}.showPosition = 1;
    d.trial{1}.recordingTime = 10;
    d.trial{1}.filename = 'reach';
    r = runProtocol(d,'mouse');
    data = load('results/mouse/mo_reach.csv');
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);
t = r.thistrial{1};
rmtestAssert('equal',t.successful,1,'reaching the correct box should be successful');
rmtestAssert(t.finishtime - t.frameInfo.startFrame(1) < 5,'the trial should end when the box is reached, not after 10 s');
rmtestAssert(size(data,1)>10 && min(data(:,1))<=130 && max(data(:,1))>=600,'the mouse path should be in the data file');

function simulatedDevice(info)
needsSimulation(info);
[workDir,oldDir] = rmtestWorkDir();
try
    options.sampleFcn = @(t) [mod(t,1) 0.5];
    rmtestStartServer(rmtestdeviceserver(3003,200,options),3003,200);
    rmtestStartServer(rmtestdeviceserver(3040,200,struct('prefix','serial_')),3040,200);
    % the mouse client is used to talk to the first simulated device
    d.setup.mouse.server = 'localhost';
    d.setup.mouse.port = 3003;
    d.setup.mouse.maxx = 1;
    d.setup.mouse.maxy = 1;
    d.setup.serialport.server = 'localhost';
    d.setup.serialport.port = 3040;
    d.setup.serialport.protocol = 'Arduino';
    d.setup.beeps{1}.frequency = 1000;
    d.setup.beeps{1}.duration = 0.1;
    d.trial{1}.stimulus = 'fixation';
    d.trial{1}.recordingTime = 2;
    d.trial{1}.filename = 'sim';
    d.trial{1}.beep{1}.time = 0.5; d.trial{1}.beep{1}.beepNumber = 1;
    d.trial{1}.beep{2}.time = 1.0; d.trial{1}.beep{2}.beepNumber = 1;
    d.trial{1}.trigger.time = 1; d.trial{1}.trigger.type = 'serialportserver'; d.trial{1}.trigger.value = 3;
    r = runProtocol(d,'sim'); %#ok<NASGU>
    data = load('results/sim/sim_sim.csv');
    w = rmtestWorld;
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);
codes = messagecodes;
rmtestAssert(size(data,2)==4,'data file: two simulated columns, time and marker');
duration = data(end,end-1) - data(1,end-1);
rmtestAssert(duration>1.8 && duration<2.3,'about 2 s should be recorded, got %.2f',duration);
rmtestAssert(any(data(:,end)==codes.firstFrame) && any(data(:,end)==codes.lastFrame),'first and last frame should be marked');
rmtestAssert(any(data(:,end)==codes.triggerSent+3),'the trigger should be marked in the data');
rmtestAssert(w.audioStarted>=1,'the beeps should be started');

function quitting(info)
needsSimulation(info);
[workDir,oldDir] = rmtestWorkDir();
try
    rmtestStartServer(keyboardserver(3002,1000,0),3002);
    w = rmtestWorld;
    % space starts trial 1, z answers, then q is held down from 7 s
    w.keyScript = [0.5 1.0 KbName('space') inf; 3.0 3.3 KbName('z') inf; 7 7.5 KbName('q') inf];
    rmtestWorld(w);
    r = runProtocol(keyboardProtocol,'quit');
    haveResults = exist('results/quit/results.mat','file');
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);
rmtestAssert(numel(r.thistrial)<5,'the experiment should stop early');
rmtestAssert(haveResults~=0,'results.mat should still be written');

function clientServer(info)
if ~info.simulatedDevices
    rmtestSkip('needs the simulated devices');
end
if ~info.simulatedPsychtoolbox
    rmtestSkip('needs the simulated Psychtoolbox (scripted keys)');
end
[workDir,oldDir] = rmtestWorkDir();
try
    rmtestStartServer(keyboardserver(3002,1000,0),3002);
    w = rmtestWorld;
    w.keyScript = [0.01 0.02 KbName('m') inf];
    rmtestWorld(w);
    params.server = 'localhost'; params.port = '3002'; % as read from the XML: strings
    kc = keyboardclient(params,[],0);
    rmtestAssert(isempty(getsample(kc)),'no sample before sampling starts');
    kc = setupRecording(kc,[pwd '/results/direct/keys'],5,[]);
    startRecording(kc,'keys',5);
    codes = messagecodes;
    markEvent(kc,codes.firstFrame);
    for k=1:400
        s = getsample(kc);
    end
    stopRecording(kc);
    summary = getDataSummary(kc);
    saved = saveFile(kc);
    haveFile = exist('results/direct/kb_keys.csv','file');
    close(kc);
    rmtestAssert('error',@() keyboardclient(struct('server','localhost','port','3999'),[],0),'Could not connect');
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);
rmtestAssert(numel(s)==3,'a keyboard sample is [time key marker]');
rmtestAssert('equal',summary.kb_firstpressed,KbName('m'));
rmtestAssert(summary.kb_RT>0 && summary.kb_RT<0.1,'RT should be measured from the first frame marker');
rmtestAssert(isequal(saved,1) && haveFile~=0,'the data file should be saved');
