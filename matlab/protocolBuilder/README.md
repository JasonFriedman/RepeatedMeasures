# Protocol builder

Functions that make it simpler to write the `generateProtocol.m` file of an experiment.
Add this directory to the path (`addpath('.../matlab/protocolBuilder')`; the
`sampleexperiments/startup.m` does it).

The options are not listed in the builder: they are **extracted from the code**
(`protocolSchema` reads the parameter definitions in the client / stimulus / response /
start classes, the same source as `makeProtocolDocumentation`). A new stimulus or a new
parameter is therefore available in the builder, checked, and shown by `protocolOptions`
without changing anything here.

## What it does for you

| Instead of | Use |
|---|---|
| looking up names in the HTML documentation | `protocolOptions`, `protocolOptions('tablet')`, `protocolOptions('trial')`, `protocolOptions('images.stateTransitions')` |
| typing `server`, `port` for every device | `p = protocolDevice(p,'tablet','maxx',48767,'maxy',30479)` (localhost and the port of `runtabletserver` are the defaults) |
| finding out about a typo when the file is validated, without knowing which line | every name and value is checked when it is set: `no option called colour. Did you mean color?` |
| `experimentDescription.trial{n}.stimulus.showText.text = ...` and 4 more lines for each instruction | `p = protocolInstruction(p,'Press space')` or `protocolInstruction(p,imageNumber)` |
| a trial per target with `defineTarget` | `p = protocolDefineTargets(p,{'Start','Left','Right'})` |
| `repmat`, `randperm`, nested loops, hand-made filenames, forgetting that repetitions overwrite each other | `conditions = protocolDesign('side',{'left','right'},'soa',[0 50 150]);` `p = protocolBlock(p,conditions,@trial,'repetitions',12,'breakEvery',24)` |
| `struct2xml`, `save`, `experiment`, `validate` | `protocolSave(p,filename)` (also prints the number of trials and the minimum duration) |

## Example

```matlab
function filename = generateProtocol(subject)
filename = ['protocols/' num2str(subject) '.xml'];

p = protocolNew;
p = protocolDevice(p,'liberty','numsensors',1,'recordOrientation',1);
p = protocolSetup(p,'images',{'left_congruent.png','left_incongruent.png',...
    'right_congruent.png','right_incongruent.png','instructions.png','whitescreen.png'},...
    'beeps',{[500 0.1]});
p = protocolCommon(p,'backgroundColor',[255 255 255],'textFeedbackColor',[0 0 0]);

p = protocolDefineTargets(p,{'Start position','Left target','Right target'},'start','keyboard');
p = protocolInstruction(p,5);    % image 5 = instructions

conditions = protocolDesign('side',[1 2],'congruency',[1 2],'soa',[0 50 150]);
for block=1:10
    p = protocolBlock(p,conditions,@trial,'repetitions',4,'name',sprintf('block%d',block),...
        'intro',sprintf('Block %d of 10',block));
end
protocolSave(p,filename);

function options = trial(c,info)
onset = 1 + c.soa/1000;
options = {'start',{'targetInSpace','target',1,'threshold',3},...
    'response',{'targetInSpace','targets',[2 3],'threshold',3},...
    'targetNum',c.side+1,...
    'stimulus',{'images','stimuli',[6 1 60 0; (c.side-1)*2+c.congruency 61 300 0]},...
    'checkMoving',onset+0.3,'checkMovingAfter',onset-0.1,...
    'checkMovingForward',struct('time',onset+0.6,'direction',[0 1 0],'minchangeframe',0.1),...
    'beep',struct('time',{onset-1,onset-0.5,onset},'beepNumber',{1,1,1}),...
    'recordingTime',5};
```

A runnable version is `sampleexperiments/matlab/protocolBuilderExample.m`.

## Reference

* `p = protocolNew(setupOption,value,...)`
* `p = protocolSetup(p,option,value,...)` – lists of structs can be written as rows:
  `'beeps',{[1000 0.1],[500 0.2]}`, `'labels',{{[0.5 0.1],20,'Left'}}`
* `p = protocolDevice(p,name,option,value,...)`
* `p = protocolCommon(p,option,value,...)` – options that are the same in every trial
* `p = protocolTrial(p,option,value,...)` – `'stimulus'`, `'response'` (= `targetType`) and
  `'start'` (= `starttrial`) take a name or `{name,option,value,...}`; lists (`beep`,
  `trigger`, `playAudioFile`) take struct arrays; `true`/`false` are allowed
* `p = protocolInstruction(p,textOrImageNumber,option,value,...)`
* `p = protocolDefineTargets(p,names,option,value,...)`
* `conditions = protocolDesign(factor,levels,...)`
* `p = protocolBlock(p,conditions,trialFunction,'repetitions',n,'shuffle',true,'name',...,'intro',...,'breakEvery',n,'breakText',...,'maxRepeats',n)`
* `protocolSummary(p)`, `protocolSave(p,filename)`
* `protocolOptions(...)`, `schema = protocolSchema`, `protocolSchemaExport('schema.json')`

`p.description` is the usual `experimentDescription` struct, so anything can still be set
by hand (e.g. `p.description.trial{3}.dontclear = 1;`); `protocolSave` validates the result.
