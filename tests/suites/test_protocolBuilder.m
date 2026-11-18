% TEST_PROTOCOLBUILDER - tests of the protocol builder (matlab/protocolBuilder)
function cases = test_protocolBuilder
cases = [];
cases = rmtestCase(cases,'the schema lists the devices, stimuli, responses and starts in the code',@schemaMatchesCode);
cases = rmtestCase(cases,'protocolOptions prints and returns options',@options);
cases = rmtestCase(cases,'a protocol can be built, saved and validated',@buildAndSave);
cases = rmtestCase(cases,'mistakes are reported where they are made',@mistakes);
cases = rmtestCase(cases,'designs and blocks: repetitions, shuffling, breaks, filenames',@blocks);
cases = rmtestCase(cases,'the builder example produces a valid protocol',@example);
cases = rmtestCase(cases,'builder protocols match hand-written ones',@equivalent);
cases = rmtestCase(cases,'the schema can be exported as JSON',@exportJSON);

function setup(info)
addpath([info.root '/matlab/protocolBuilder']);

function schemaMatchesCode(info) %#ok<*DEFNU>
setup(info);
s = protocolSchema;
suffix = struct('devices','client','stimulus','stimulus','targetType','response','starttrial','start','staircases','staircase');
groups = fieldnames(suffix);
for g=1:numel(groups)
    names = fieldnames(s.(groups{g}));
    rmtestAssert(numel(names)>=1,'no %s found',groups{g});
    for k=1:numel(names)
        rmtestAssert(exist([info.root '/matlab/@' names{k} suffix.(groups{g})],'dir')==7,...
            '%s %s in the schema has no class @%s%s (check params.classname)',groups{g},names{k},names{k},suffix.(groups{g}));
    end
    d = dir([info.root '/matlab/@*' suffix.(groups{g})]);
    onDisk = regexprep({d.name},['^@(.*)' suffix.(groups{g}) '$'],'$1');
    onDisk = setdiff(onDisk,{'','socket','character'});
    if strcmp(groups{g},'starttrial') || strcmp(groups{g},'targetType') || strcmp(groups{g},'stimulus')
        missing = setdiff(onDisk,names);
        rmtestAssert(isempty(missing),'%s classes missing from the schema: %s',groups{g},sprintf('%s ',missing{:}));
    end
end
rmtestAssert(any(strcmp({s.trial.name},'recordingTime')) && any(strcmp({s.setup.name},'images')),'setup / trial options missing');
rmtestAssert(any(strcmp({s.devices.tablet.name},'server')),'devices should include the options of socketclient');

function options(info)
setup(info);
list = protocolOptions('tablet');
rmtestAssert(any(strcmp({list.name},'maxx')),'tablet should have the option maxx');
list = protocolOptions('trial.beep');
rmtestAssert('equal',sort({list.name}),{'beepNumber','time'});
list = protocolOptions('images.stateTransitions');
rmtestAssert(any(strcmp({list.name},'newState')),'nested options should be found');
txt = evalc('protocolOptions');
rmtestAssert(~isempty(strfind(txt,'pointToPoint')) && ~isempty(strfind(txt,'liberty')),'the overview should list responses and devices'); %#ok<STREMP>
txt = evalc('protocolOptions(''stimulus.showText'')');
rmtestAssert(~isempty(strfind(txt,'showBeforeStart')),'the options of showText should be printed'); %#ok<STREMP>
rmtestAssert('error',@() protocolOptions('tablett'),'Did you mean tablet');

function buildAndSave(info)
setup(info);
[workDir,oldDir] = rmtestWorkDir();
try
    p = protocolNew('monitorWidth',43.2);
    p = protocolDevice(p,'tablet','maxx',48767,'maxy',30479);
    p = protocolDevice(p,'keyboard');
    p = protocolSetup(p,'images',{'Female1.png'},'beeps',{[1000 0.1],[500 0.2]},...
        'targetPosition',[0.5 0.2;0.5 0.8],'labels',{{[0.5 0.1],20,'Top'}});
    p = protocolCommon(p,'backgroundColor',[0 0 0]);
    p = protocolInstruction(p,'Hello');
    p = protocolInstruction(p,1,'start','dontWait','recordingTime',2);
    p = protocolTrial(p,'stimulus','fixation','response',{'pointToPoint','start',1,'end',2,'repetitions',5},...
        'start','keyboard','recordingTime',30,'filename','p2p','showPosition',true,...
        'beep',struct('time',{1 2},'beepNumber',{1 2}));
    protocolSave(p,'protocols/built.xml','quiet',true);
    back = convert(xmltree('protocols/built.xml'));
    s = protocolSummary(p);
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);
rmtestAssert('equal',back.setup.tablet.port,'3009','the standard port of the tablet server should be used');
rmtestAssert('equal',back.setup.keyboard.server,'localhost');
rmtestAssert('equal',back.setup.beeps{2}.frequency,'500');
rmtestAssert('equal',back.setup.labels.text,'Top');
rmtestAssert('equal',back.trial{1}.stimulus.showText.text,'Hello');
rmtestAssert('equal',back.trial{1}.starttrial,'keyboard');
rmtestAssert('equal',back.trial{2}.stimulus.showImage.stimuli,'1');
rmtestAssert('equal',back.trial{3}.targetType.pointToPoint.repetitions,'5');
rmtestAssert('equal',back.trial{3}.showPosition,'1','true should be written as 1');
rmtestAssert('equal',back.trial{3}.beep{2}.time,'2');
rmtestAssert('equal',str2num(back.common.backgroundColor),[0 0 0]); %#ok<ST2NM>
rmtestAssert('equal',[s.trials s.recorded],[3 1]);
rmtestAssert('equal',s.devices,{'keyboard','tablet'});

function mistakes(info)
setup(info);
p = protocolNew;
rmtestAssert('error',@() protocolDevice(p,'tablett'),'Did you mean tablet');
rmtestAssert('error',@() protocolDevice(p,'mouse'),'needs: maxx, maxy');
rmtestAssert('error',@() protocolDevice(p,'tablet','maxx',1,'maxy',1,'prot',5),'no option called prot');
rmtestAssert('error',@() protocolSetup(p,'monitorwidth',50),'Did you mean monitorWidth');
rmtestAssert('error',@() protocolSetup(p,'keyboard',1),'use protocolDevice');
rmtestAssert('error',@() protocolSetup(p,'mouseTargets',[0 0 1]),'should have 4 column');
rmtestAssert('error',@() protocolTrial(p,'stimulus','showtext','recordingTime',1),'Did you mean showText');
rmtestAssert('error',@() protocolTrial(p,'stimulus','showText','recordingTime',1),'showText needs: text');
rmtestAssert('error',@() protocolTrial(p,'stimulus',{'showText','text','a','colour',[1 1 1]},'recordingTime',1),'Did you mean color');
rmtestAssert('error',@() protocolTrial(p,'stimulus','fixation'),'recordingTime must be specified');
rmtestAssert('error',@() protocolTrial(p,'stimulus','fixation','recordingTime',2),'filename is needed');
rmtestAssert('error',@() protocolTrial(p,'stimulus','fixation','recordingTime','2','recording',0),'single number');
rmtestAssert('error',@() protocolTrial(p,'stimulus','fixation','recordingTime',2,'recording',0,'backgroundColor',[0 0]),'3 column');
rmtestAssert('error',@() protocolTrial(p,'response',{'targetInSpace','threshold',3},'recordingTime',2,'recording',0),'needs: targets');
rmtestAssert('error',@() protocolTrial(p,'start','keybord','recordingTime',2,'recording',0),'Did you mean keyboard');
p = protocolTrial(p,'stimulus','fixation','recordingTime',2,'filename','a');
rmtestAssert('error',@() protocolTrial(p,'stimulus','fixation','recordingTime',2,'filename','a'),'already used by trial 1');
rmtestAssert('error',@() protocolSave(p,'protocols/x.xml'),'no recording device');
rmtestAssert('error',@() protocolInstruction(p,3),'Image 3 is not defined');

function blocks(info)
setup(info);
c = protocolDesign('side',{'left','right'},'soa',[0 50 150]);
rmtestAssert('equal',numel(c),6);
rmtestAssert('equal',{c(1).side,c(4).side},{'left','right'});
rmtestAssert('equal',[c.soa],[0 50 150 0 50 150]);
rmtestAssert('equal',c(5).index,[2 2]);
p = protocolNew;
p = protocolDevice(p,'keyboard');
f = @(c,info) {'stimulus',{'showText','text',c.side},'response','keyboard','recordingTime',3,'targetNum',1+strcmp(c.side,'right')};
p = protocolBlock(p,c,f,'repetitions',4,'name','main','intro','Get ready','breakEvery',10,'maxRepeats',2);
t = p.description.trial;
rmtestAssert('equal',numel(t),1 + 24 + 2,'intro + 24 trials + 2 breaks');
isTrial = cellfun(@(x) isfield(x,'filename'),t);
names = cellfun(@(x) x.filename,t(isTrial),'UniformOutput',false);
rmtestAssert('equal',numel(unique(names)),24,'filenames should be unique');
rmtestAssert(all(strncmp(names,'main_',5)),'filenames should start with the block name');
sides = cellfun(@(x) x.stimulus.showText.text,t(isTrial),'UniformOutput',false);
rmtestAssert('equal',sum(strcmp(sides,'left')),12,'each condition should occur 4 times');
rmtestAssert('equal',find(~isTrial),[1 12 23],'breaks should come after every 10 trials');
s = protocolSummary(p);
rmtestAssert('equal',s.blocks,{'main'});
% without shuffling the order is that of the design
p2 = protocolBlock(protocolDevice(protocolNew,'keyboard'),c,f,'shuffle',false);
sides = cellfun(@(x) x.stimulus.showText.text,p2.description.trial,'UniformOutput',false);
rmtestAssert('equal',sides,{'left','left','left','right','right','right'});

function example(info)
setup(info);
[workDir,oldDir] = rmtestWorkDir();
try
    filename = protocolBuilderExample('s1');
    e = experiment(filename,'testData');
    n = numTrials(e);
    closelog(e);
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);
rmtestAssert('equal',n,3 + 1 + 2*(1 + 24 + 1) + 1);

function equivalent(info)
% the CentreOut sample, written with the builder, gives the same protocol
setup(info);
[workDir,oldDir] = rmtestWorkDir();
try
    generateCentreOutProtocol;
    byHand = convert(xmltree('protocols/CentreOut.xml'));
    pedal = {'pedal','joystickType',2,'joystickButton',3};
    p = protocolNew('monitorWidth',43.2,'viewingDistance',40,'xshift',0);
    p = protocolDevice(p,'tablet','maxx',43600,'maxy',32799);
    p = protocolInstruction(p,'Press pedal to start','start',pedal);
    for k=0:8
        p = protocolTrial(p,'stimulus',{'showText','text',sprintf('Target %d',k)},...
            'response',{'defineTarget','targetNum',k+1},'recordingTime',inf,'recording',0,'start','dontWait');
    end
    for k=1:8
        p = protocolTrial(p,'stimulus',{'showText','text',sprintf('0 to %d',k)},...
            'response',{'pointToPoint','start',1,'end',k+1,'repetitions',10},...
            'recordingTime',30,'recording',1,'filename',sprintf('0%d',k),'start',pedal);
    end
    protocolSave(p,'protocols/CentreOutBuilder.xml','quiet',true);
    built = convert(xmltree('protocols/CentreOutBuilder.xml'));
catch err
    rmtestCleanup(workDir,oldDir); rethrow(err);
end
rmtestCleanup(workDir,oldDir);
rmtestAssert('equal',numel(built.trial),numel(byHand.trial));
rmtestAssert(isequal(orderfields(built.setup.tablet),orderfields(byHand.setup.tablet)),'the tablet setup should be the same');
for k=1:numel(byHand.trial)
    rmtestAssert(isequal(orderfields(built.trial{k}),orderfields(byHand.trial{k})),'trial %d differs from the hand-written protocol',k);
end

function exportJSON(info)
setup(info);
filename = [tempname '.json'];
protocolSchemaExport(filename);
txt = fileread(filename);
delete(filename);
rmtestAssert(numel(txt)>20000,'the JSON file is too small');
rmtestAssert(~isempty(strfind(txt,'"recordingTime"')) && ~isempty(strfind(txt,'"pointToPoint"')),'options are missing from the JSON'); %#ok<STREMP>
rmtestAssert(sum(txt=='{')==sum(txt=='}') && sum(txt=='[')==sum(txt==']'),'brackets should be balanced');
if exist('jsondecode') %#ok<EXIST>
    s = jsondecode(txt);
    rmtestAssert(isfield(s,'setup') && isfield(s,'stimulus') && isfield(s.devices,'tablet'),'the JSON should decode to the schema');
end
