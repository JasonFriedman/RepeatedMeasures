% PROTOCOLBUILDEREXAMPLE - a reaching experiment written with the protocol builder
%
% filename = protocolBuilderExample(subject)
%
% A flanker-like pointing task with a Liberty tracker: the targets are defined first,
% then 2 blocks of side (left/right) x congruency x SOA are presented in random order.
% Compare with the hand-written generate*Protocol.m files: the devices, instructions,
% design, repetitions, shuffling, breaks, unique filenames, saving and validation are
% handled by the builder, and every name is checked as it is used.
%
% Use protocolOptions to see what is available, e.g. protocolOptions('targetInSpace').
function filename = protocolBuilderExample(subject)
if nargin<1
    subject = 'test';
end
if isnumeric(subject)
    subject = num2str(subject);
end
filename = ['protocols/BuilderExample_' subject '.xml'];

p = protocolNew('monitorWidth',70,'viewingDistance',68);
p = protocolDevice(p,'liberty','numsensors',1,'recordOrientation',1);
p = protocolSetup(p,'images',{'Female1.png','Female2.png','Male1.png','Male2.png'},...
    'beeps',{[500 0.1]});   % beep 1: 500 Hz for 0.1 s

p = protocolDefineTargets(p,{'Start position','Left target','Right target'},'start','keyboard');
p = protocolInstruction(p,'Point to the side of the face');

conditions = protocolDesign('side',{'left','right'},'congruent',[1 0],'soa',[0 50 150]);
for block=1:2
    p = protocolBlock(p,conditions,@trial,'repetitions',2,'name',sprintf('block%d',block),...
        'intro',sprintf('Block %d of 2',block),'breakEvery',12,'maxRepeats',3);
end
p = protocolInstruction(p,'Thank you!');
protocolSave(p,filename);

function options = trial(c,info) %#ok<INUSD>
targetTime = 1; % seconds
onset = targetTime + c.soa/1000;
image = 1 + 2*strcmp(c.side,'right') + ~c.congruent;   % image 1..4
options = {'start',{'targetInSpace','target',1,'threshold',3},...
    'response',{'targetInSpace','targets',[2 3],'threshold',3},...
    'targetNum',2 + strcmp(c.side,'right'),...
    'stimulus',{'images','stimuli',[image 61 300 0]},...
    'checkMoving',onset + 0.3,...          % must start moving within 300 ms
    'checkMovingAfter',onset - 0.1,...     % and not before
    'beep',struct('time',{onset-1,onset-0.5,onset},'beepNumber',{1,1,1}),...
    'recordingTime',5};
