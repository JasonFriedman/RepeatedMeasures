% READTRIALPARAMETERS - read the parameters describing how this trial is to be run, and set defaults when appropriate

function [thistrial,params] = readTrialParameters(e,thistrialprotocol,experimentdata,validating)

if nargin<4 || isempty(validating)
    validating = 0;
end

movementonsetParams.name = {'type','direction','threshold'};
movementonsetParams.type = {'number','number','number'};
movementonsetParams.default = {1,-3,0.1};
movementonsetParams.required=  [1 0 0];
movementonsetParams.description = {'Type of movement onset to make targets appear / disappear (1 = movement threshold in a frame). Support must be provided by the stimulus or client.',...
    'direction to start moving when detecting movement onset (x=1,y=2,z=3), use negative values if appropriate.',...
    'threshold to start moving when detecting movement onset (i.e. how far you need to move in a single frame)'};
movementonsetParams.classdescription = 'Make targets appear / disappear based on some type of movement';
movementonsetParams.classname = 'movementonset';

audioFileParams.name = {'number','starttime'};
audioFileParams.type = {'number','number'};
audioFileParams.default = {1,0};
audioFileParams.required=  [1 1];
audioFileParams.description = {'Number of the file to play (from the .wav files specified in experimendata.setup.sounds)','start time from the start of the trial (in seconds)'};
audioFileParams.classdescription = 'Play a wav file at a specified time';
audioFileParams.classname = 'playAudioFile';

beepParams.name = {'time','frequency','duration','volume'};
beepParams.type = {'number','number','number','number'};
beepParams.default = {0,400,0.15,0.4};
beepParams.required = [1 0 0 0];
beepParams.description = {'Onset time','beep frequency (in Hz) - CURRENTLY IGNORED','beep duration (in seconds) - CURRENTLY IGNORED','volume - CURRENTLY IGNORED'};
beepParams.classdescription = 'Beeps throughout the trial';
beepParams.classname = 'beep';

params.name = {'checkMoving','blockcounter','waitTimeBefore','showPosition','drawFixation','targetNum','textFeedback',...
    'textFeedbackShowBackground','checkRecording','auditoryFeedback','filename','recordingTime','movementonset','recording','playAudioFile',...
    'boxes','labels','beep','backgroundColor','stimulus','starttrial','targetType'};
params.type = {'number','number','number','number','number','number','number',...
    'number','number','number','string','number',movementonsetParams,'number',audioFileParams,...
    'matrix','matrix',beepParams,'matrix_1_3','ignore','ignore','ignore'};
params.default = {0,          1,             0,               0,             1,            NaN,         1,...
    0,                           1,               1,                 '',        [],             [],              NaN, [],...
    [],[],[],[0 0 0],[],[],[]};
params.description = {'Whether to check the subject is still moving at this time','counter (used with triggers)',...
    'time to wait before showing the main stimulus (fixation is usually shown)','whether the current location should be shown (depends on the input device)',...
    'whether to draw a fixation point during waitTimeBefore','correct target number','whether to display text feedback after the trial',...
    'whether to show the background when giving feedback','whether to check the recording at the end of the trial (and give feedback if there is a problem, e.g. missing markers)',...
    'whether to provide auditory feedback (usually when incorrect)','filename to save the results','recording time in seconds',...
    'how movement onset is determined','whether to record','details of audio (wav) files to play',...
    'which boxes to show','which labels to show','beeps througout the trial','Background color (1x3 RGB matrix, [0 0 0] = black, [255 255 255] = white)',...
    'the stimulus to show for this trial','how the trial starts','the response for this trial'};
params.required = [0 0 0 0 0 0 0 ...
    0 0 0 0 1 0 0 0 ...
    0 0 0 0 1 0 0];
params.classdescription = 'The trial is the basic unit of the experiment.';
params.classname = 'trial';

if nargout>1
    % When making the documentation, include all the possible stimuli / starts / respone
    thisfile = which('makeProtocolDocumentation');
    % get the directory
    pathstr = fileparts(thisfile);
    
    ends = {'response','start','stimulus'};
    for m=1:3
        % look for stimuli / starts / response
        dirs = dir([pathstr '/@*' ends{m}]);
        count = 0;
        clear paramstruct;
        for k=1:numel(dirs)
            eval(['[p,p] = ' dirs(k).name(2:end) '();']);
            p.classname = strrep(p.classname,ends{m},'');
            % don't include the superclass
            if ~isempty(p.classname)
                count = count+1;
                paramstruct{count} = p;
            end
        end
        params.type{end-m+1} = paramstruct;
    end
    thistrial = [];
    return;
end

thistrial = readParameters(params,thistrialprotocol);

% set defaults (that are not set by the protocol file)
thistrial.questSuccess = -1;
thistrial.playsound = 0; % This will be set to 1 if there is an error
thistrial.dontclear = 0;
thistrial.sampleWhenNotRecording = 0;
thistrial.stimuliFrames = 0; % If there are stimuli to present, this will be overwritten during the trial setup stage

% read in playAudioFile, if appropriate
if ~isempty(thistrial.playAudioFile)
    thistrial = readAudioFileDetails(thistrial,experimentdata,validating);
end

% Default is to display all boxes / labels on every trial
if ~isempty(experimentdata.boxes(1)) && isempty(thistrial.boxes)
    thistrial.boxes = 1:size(experimentdata.boxes,1);
end
if ~isempty(experimentdata.labels)
    thistrial.labels = 1:numel(experimentdata.labels);
end
if experimentdata.recordingStimuli
    thistrial.imageArray = [];
end

if ~isempty(thistrial.movementonset)
    thistrial.movementonset.type = - thistrial.movementonset.type;
end

if ~isfield(thistrialprotocol,'stimulus')
    error('Each trial must specify a stimulus');
end

if isstruct(thistrialprotocol.stimulus)
    stimulusname_all = fields(thistrialprotocol.stimulus);
    stimulusname = stimulusname_all{1};
    eval(['thistrial.thisstimulus = ' stimulusname 'stimulus(thistrialprotocol.stimulus.' stimulusname ',experimentdata);']);
else
    eval(['thistrial.thisstimulus = ' thistrialprotocol.stimulus 'stimulus([],experimentdata);']);
end
writetolog(e,'Read stimulus');

if ~isfield(thistrialprotocol,'targetType')
    thistrial.thisresponse = dummyresponse(struct);
elseif isstruct(thistrialprotocol.targetType)
    responsename_all = fields(thistrialprotocol.targetType);
    responsename = responsename_all{1};
    if ~exist([responsename 'response'],'file')
        error(['These is no class called ' responsename 'response']);
    end
    eval(['thistrial.thisresponse = ' responsename 'response(thistrialprotocol.targetType.' responsename ');']);
else
    if ~exist([thistrialprotocol.targetType 'response'],'file')
        error(['These is no class called ' thistrialprotocol.targetType 'response']);
    end
    eval(['thistrial.thisresponse = ' thistrialprotocol.targetType 'response(struct);']);
end
writetolog(e,'Read target type');

if ~isfield(thistrialprotocol,'starttrial')
    thistrial.thisstarttrial = dontWaitstart(struct);
elseif isstruct(thistrialprotocol.starttrial)
    starttrial_all = fields(thistrialprotocol.starttrial);
    starttrialname = starttrial_all{1};
    if ~exist([starttrialname 'start'],'file')
        error(['There is no class called ' starttrialname 'start']);
    end
    eval(['thistrial.thisstarttrial = ' starttrialname 'start(thistrialprotocol.starttrial.' starttrialname ',experimentdata);']);
else
    if ~exist([thistrialprotocol.starttrial 'start'],'file')
        error(['There is no class called ' thistrialprotocol.starttrial 'start']);
    end
    eval(['thistrial.thisstarttrial = ' thistrialprotocol.starttrial 'start(struct,experimentdata);']);
end
writetolog(e,'Read starttrial');

if ~isnan(thistrial.recording) && thistrial.recording && isempty(thistrial.filename)
    error('Must specify a filename when recording');
end
