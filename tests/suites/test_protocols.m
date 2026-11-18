% TEST_PROTOCOLS - protocol files: XML round trip, the sample protocols and error reporting
function cases = test_protocols
cases = [];
cases = rmtestCase(cases,'struct -> XML -> struct round trip',@roundTrip);
cases = rmtestCase(cases,'protocol files in sampleexperiments/protocols can be loaded',@loadCommitted);
d = dir([fileparts(fileparts(fileparts(mfilename('fullpath')))) '/sampleexperiments/matlab/generate*Protocol.m']);
for k=1:numel(d)
    name = d(k).name(1:end-2);
    cases = rmtestCase(cases,['sample generator ' name ' produces a valid protocol'],@(info) runGenerator(info,name));
end
cases = rmtestCase(cases,'a protocol without a recording device is rejected',@noDevice);
cases = rmtestCase(cases,'an unknown stimulus / response / start is rejected',@unknownClasses);
cases = rmtestCase(cases,'unknown or missing trial parameters are rejected',@badTrialParameters);
cases = rmtestCase(cases,'misspelled or misplaced options are rejected with a suggestion',@misspelled);
cases = rmtestCase(cases,'repeated filenames are rejected',@repeatedFilenames);
cases = rmtestCase(cases,'resources that trials refer to must be defined in setup',@missingResources);
cases = rmtestCase(cases,'common parameters are copied to every trial',@commonParameters);

function d = minimalProtocol
d.setup.keyboard.server = 'localhost';
d.setup.keyboard.port = 3002;
d.trial{1}.stimulus.showText.text = 'Hello';
d.trial{1}.recordingTime = 1;
d.trial{1}.recording = 0;
d.trial{2}.stimulus = 'fixation';
d.trial{2}.recordingTime = 2;
d.trial{2}.filename = 'trial2';

function e = writeAndLoad(d)
save(struct2xml(d),'protocols/test.xml');
e = experiment('protocols/test.xml','results/test');

function check(d)
% write the protocol, validate it, and always close the log file
e = writeAndLoad(d);
try
    validate(e);
catch err
    closelog(e);
    rethrow(err);
end
closelog(e);

function roundTrip(info) %#ok<*INUSD,*DEFNU>
[workDir,oldDir] = rmtestWorkDir();
d = minimalProtocol;
d.setup.mouseTargets = [0 0 0.25 0.5;0.75 0 0.25 0.5];
d.setup.images = {'a.png','b.png'};
save(struct2xml(d),'protocols/roundtrip.xml');
back = convert(xmltree('protocols/roundtrip.xml'));
rmtestCleanup(workDir,oldDir);
rmtestAssert('equal',back.setup.keyboard.port,'3002','numbers are stored as strings in the XML');
rmtestAssert('equal',str2num(back.setup.mouseTargets),d.setup.mouseTargets); %#ok<ST2NM>
rmtestAssert('equal',back.setup.images,d.setup.images);
rmtestAssert('equal',back.trial{1}.stimulus.showText.text,'Hello');
rmtestAssert('equal',back.trial{2}.stimulus,'fixation');
rmtestAssert('equal',numel(back.trial),2);

function loadCommitted(info)
d = dir([info.root '/sampleexperiments/protocols/*.xml']);
rmtestAssert(numel(d)>5,'Expected sample protocol files');
[workDir,oldDir] = rmtestWorkDir();
problems = {};
for k=1:numel(d)
    try
        e = experiment([info.root '/sampleexperiments/protocols/' d(k).name],'results/loading');
        n = numTrials(e);
        closelog(e);
        if n<1
            problems{end+1} = [d(k).name ': no trials']; %#ok<AGROW>
        end
    catch err
        problems{end+1} = [d(k).name ': ' err.message]; %#ok<AGROW>
    end
end
rmtestCleanup(workDir,oldDir);
rmtestAssert(isempty(problems),'%s',sprintf('\n    %s',problems{:}));

function runGenerator(info,name)
[workDir,oldDir] = rmtestWorkDir();
try
    feval(name); % writes protocols/<name>.xml and validates it
    made = dir('protocols/*.xml');
catch err
    rmtestCleanup(workDir,oldDir);
    rethrow(err);
end
rmtestCleanup(workDir,oldDir);
rmtestAssert(numel(made)>=1,'%s did not write a protocol file',name);

function noDevice(info)
[workDir,oldDir] = rmtestWorkDir();
d = minimalProtocol;
d.setup = rmfield(d.setup,'keyboard');
d.setup.monitorWidth = 50;
try
    rmtestAssert('error',@() check(d),'at least one recording device');
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);

function unknownClasses(info)
[workDir,oldDir] = rmtestWorkDir();
try
    d = minimalProtocol; d.trial{2}.stimulus = 'doesNotExist';
    rmtestAssert('error',@() check(d),'doesNotExist');
    d = minimalProtocol; d.trial{2}.targetType = 'doesNotExist';
    rmtestAssert('error',@() check(d),'no class called doesNotExistresponse');
    d = minimalProtocol; d.trial{2}.starttrial = 'doesNotExist';
    rmtestAssert('error',@() check(d),'no class called doesNotExiststart');
    d = minimalProtocol; d.setup.unknownSetupField = 1;
    rmtestAssert('error',@() check(d),'Unknown field unknownSetupField');
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);

function badTrialParameters(info)
[workDir,oldDir] = rmtestWorkDir();
try
    d = minimalProtocol; d.trial{2}.notAParameter = 1;
    rmtestAssert('error',@() check(d),'Unknown field notAParameter in trial');
    d = minimalProtocol; d.trial{2} = rmfield(d.trial{2},'recordingTime');
    rmtestAssert('error',@() check(d),'Must specify recordingTime for trial');
    d = minimalProtocol; d.trial{2} = rmfield(d.trial{2},'filename');
    rmtestAssert('error',@() check(d),'filename');
    d = minimalProtocol; d.trial{1}.stimulus.showText.colour = [1 2 3];
    rmtestAssert('error',@() check(d),'Unknown field colour');
    d = minimalProtocol; d.trial{2}.backgroundColor = [0 0];
    rmtestAssert('error',@() check(d),'Width of matrix backgroundColor');
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);

function misspelled(info)
[workDir,oldDir] = rmtestWorkDir();
try
    d = minimalProtocol; d.trial{2}.startTrial = 'keyboard';
    rmtestAssert('error',@() check(d),'Unknown field startTrial in trial. Did you mean starttrial');
    % a trial option put inside the stimulus (it used to be ignored silently)
    d = minimalProtocol; d.trial{1}.stimulus.startTrial = 'keyboard';
    rmtestAssert('error',@() check(d),'did you mean trial\{n\}.starttrial rather than trial\{n\}.stimulus.startTrial');
    d = minimalProtocol; d.trial{1}.stimulus.targetType = 'dummy';
    rmtestAssert('error',@() check(d),'trial\{n\}.targetType rather than');
    % two stimuli
    d = minimalProtocol; d.trial{1}.stimulus.fixation = struct;
    d.trial{1}.stimulus.fixation.dummyNotUsed = [];
    d.trial{1}.stimulus = struct('showText',struct('text','a'),'fixation','');
    rmtestAssert('error',@() check(d),'should contain exactly one stimulus');
    d = minimalProtocol; d.trial{2}.stimulus = struct('showtext',struct('text','a'));
    rmtestAssert('error',@() check(d),'no stimulus called showtext. Did you mean showText');
    d = minimalProtocol; d.trial{2}.targetType = struct('Keyboard',struct('keytopress',{{'a'}}));
    rmtestAssert('error',@() check(d),'no response called Keyboard. Did you mean keyboard');
    % options of a class without options of its own (the keyboard client)
    d = minimalProtocol; d.setup.keyboard.Port = 3002;
    rmtestAssert('error',@() check(d),'Unknown field Port in keyboard. Did you mean port');
    d = minimalProtocol; d.trial{1}.stimulus.showText.Color = [1 1 1];
    rmtestAssert('error',@() check(d),'Unknown field Color in showTextstimulus. Did you mean color');
    d = minimalProtocol; d.trial{2}.beep.Time = 1;
    rmtestAssert('error',@() check(d),'Unknown field Time in beep. Did you mean time');
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);

function repeatedFilenames(info)
[workDir,oldDir] = rmtestWorkDir();
try
    d = minimalProtocol;
    d.trial{3} = d.trial{2};
    rmtestAssert('error',@() check(d),'Repeated filenames');
    d.trial{3}.filename = 'trial3';
    check(d);
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);

function missingResources(info)
[workDir,oldDir] = rmtestWorkDir();
try
    d = minimalProtocol; d.trial{2}.beep.time = 1; d.trial{2}.beep.beepNumber = 1;
    rmtestAssert('error',@() check(d),'must specify beep details in setup');
    d = minimalProtocol; d.trial{2}.trigger.time = 1; d.trial{2}.trigger.type = 'serial';
    rmtestAssert('error',@() check(d),'without serial in the setup');
    d = minimalProtocol; d.trial{2}.stimulus = struct('showImage',struct('stimuli',3));
    d.setup.images = {'Female1.png'};
    rmtestAssert('error',@() check(d),'not enough images');
    d = minimalProtocol; d.trial{2}.starttrial.mouseInBox.targets = 2;
    d.setup.mouseTargets = [0 0 0.1 0.1];
    rmtestAssert('error',@() check(d),'not enough mouseTargets');
    d = minimalProtocol; d.trial{2}.DRT.keyToPress = 'b';
    rmtestAssert('error',@() check(d),'Must define beeps');
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);

function commonParameters(info)
[workDir,oldDir] = rmtestWorkDir();
try
    d = minimalProtocol;
    d.common.starttrial = 'keyboard';
    d.common.showPosition = 1;
    e = writeAndLoad(d);
    p = get(e,'protocol');
    closelog(e);
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);
rmtestAssert('equal',p.trial{1}.starttrial,'keyboard');
rmtestAssert('equal',p.trial{2}.showPosition,'1');
