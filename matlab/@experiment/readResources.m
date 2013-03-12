% READRESOURCES - Read strings, labels, symbols (if they exist) and other default values

function [experimentdata,params] = readResources(e,validating)

if nargin<2
    validating = 0;
end

frustumparams.name = {'left','right','bottom','top','nearVal','farVal'};
frustumparams.type = {'number','number','number','number','number','number'};
frustumparams.description = {'left side','right side','bottom','top','near plane location','far plane location'};
frustumparams.default = {-5,5,-5,5,2,500};
frustumparams.required = [0 0 0 0 0 0];
frustumparams.classname = 'frustum';
frustumparams.classdescription = 'Frustum parameters for viewing transformation';

vrparams.name = {'scale','rotate','translation','stereomode','eyedistance','cameralocation','center','up','frustum'};
vrparams.type = {'matrix_1_3','matrix_1_3','matrix_1_3','number','number','matrix_1_3','matrix_1_3','matrix_1_3',frustumparams};
vrparams.description = {'Scale factor for the hand','Rotation to apply to the hand','Translation to apply to the hand',...
    'stereomode (see Psychtoolbox for the values)','eye distance (when using stereo)','camera location (x,y,z)',...
    'center of scene (x,y,z)','up direction (x,y,z)','Viewing transformation'};
vrparams.default = {[1 1 1],[0 0 0],[0 0 0],0,1,[0 2 22],[5 5 5],[0 1 0],readParameters(frustumparams,[])};
vrparams.required = [0 0 0 0 0 0 0 0 0];
vrparams.classdescription = 'rendering parameters for virtual reality';
vrparams.classname = 'vr';
% when viewing from above, these should be
% experimentdata.vr.cameralocation = [0 22 0];
% experimentdata.vr.center = [0 0 0];
% experimentdata.vr.up = [0 0 -1];

labelparams.name = {'location','fontSize','text'};
labelparams.type = {'matrix_1_2','number','string'};
labelparams.description = {'Location on screen for label (x,y), in the range 0-1','Font size (pts)','text to display'};
labelparams.default = {[0 0],12,''};
labelparams.required = [1 1 1];
labelparams.classname = 'labels';
labelparams.classdescription = 'Text to show on the screen throughout the experiment (e.g. target labels)';

params.name = {'images','strings','sounds','symbols','monitorWidth',...
    'viewingDistance','xshift','framerate','vr','MCtrigger','mouseTargets','targetPosition','boxes','labels'};
params.type = {'cellarray','cellarray','cellarray','cellarray','number',...
    'number','number','number',vrparams,'number','matrix_n_4','matrix_n_2','matrix_n_4',labelparams};
params.description = {'Cell array of the filenames of the images (which are in the stimuli directory)',...
    'Strings to replace the default (for feedback, etc). Each item should have fields name (name of string to replace) and value (the new string to use)',...
    'Cell array of the filenames of .wav sound files to play (which are in the stimuli directory). All files need to have the same sample frequency and number of channels.',...
    'A cell array of strings to display (e.g. {''<'',''>''})',...
    'The width of the monitor in cm',...
    'The viewing distance in cm',...
    'Horizontal shift of stimuli from the center of the screen',...
    'Frame rate to aim for (if the program can''t keep up with the monitor frame rate',...
    'details of the vr setup (if vrstimulus is going to be used)',...
    'details of the DAQ card trigger (1 = input, 2 = output, empty if not used)',...
    'details of mouse targets (that can be clicked). Each row should be (x,y,width,height), in the range 0-1',...
    'details of target positions. Each row should be (x,y) or (x,y,z), depending on the recording device used. These values can be overridden using the defineTarget response.',...
    'details of boxes to show on the screen. Each row should be (x,y,width,height), in the range 0-1',...
    'list of labels (strings) that can be shown'};
params.default = {[],[],[],[],70,...
    68,0,NaN,[],[],[],[],NaN,[]};
params.required = [0 0 0 0 0 0 0 0 0 0 0 0 0 0];

if nargout>1
    % If making documentation, add all clients, otherwise just the relevant ones
    for k=1:numel(e.allclients)
        if ~strcmp(e.allclients{k},'socket')
            count = numel(params.name)+1;
            params.name{count} = e.allclients{k};
            cn = [e.allclients{k} 'client'];
            eval(['[p,p] = ' cn '([]);']);
            params.type{count} = p;
            params.description{count} = p.classdescription;
            params.default{count} = [];
            params.required(count) = 0;
        end
    end
else
    if isempty(e.devices)
        error('There must be at least one recording device');
    end
    devicesfields = fields(e.devices);
    for k=1:numel(devicesfields)
        params.name{numel(params.name)+1} = devicesfields{k};
        params.type{numel(params.type)+1} = 'ignore';
        params.description{numel(params.description)+1} = '';
        params.default{numel(params.default)+1} = [];
        params.required(numel(params.required)+1) = 0;
    end
end
params.classdescription = 'General parameters for the entire expriment';
params.classname = 'experimentdata';

if nargout>1
    experimentdata = [];
    return;
end

% find the parent directory of MatlabExperiment
thisfile = which('experiment');
pathstr = fileparts(thisfile);
% allow for either slash type
parentDir = strrep(pathstr,'matlab\@experiment','');
parentDir = strrep(parentDir,'matlab/@experiment','');

imageDir = 'stimuli/';
% If there is no stimuli dir, use the default stimuli
if ~exist(imageDir,'dir')
    imageDir = [parentDir 'stimuli/'];
end

soundDir = 'sounds/';
% If there is no sound dir, use the default sounds
if ~exist(soundDir,'dir')
    soundDir = [parentDir 'sounds/'];
end
% Read in annoying beep
[experimentdata.annoyingBeep,experimentdata.annoyingBeepf] = wavread([soundDir 'Buzz.wav']);

% Default texts
experimentdata.texts = defaultstrings;

% Set some defaults
experimentdata = readParameters(params,e.protocol.setup,experimentdata);

if ~isempty(experimentdata.images)
    imagenames = experimentdata.images;
    experimentdata = rmfield(experimentdata,'images');
    numimages = numel(imagenames);
    experimentdata.images = cell(numimages,1);
    for m=1:numimages
        [experimentdata.images{m},map,experimentdata.alpha{m}] = imread([imageDir imagenames{m}]);
        if ~isempty(map)
            error('Cannot deal with images with colormap. ');
        end
        if ~isa(experimentdata.images{m},'uint8')
            error(['Requires 8 bit images. This file is not:' imageDir imagenames{m}]);
        end
        % If actually a grey scale image, convert to one channel
        if length(size(experimentdata.images{m}))==3
            channel1 = experimentdata.images{m}(:,:,1);
            channel2 = experimentdata.images{m}(:,:,2);
            channel3 = experimentdata.images{m}(:,:,3);
            if all(channel1(:)==channel2(:)) && all(channel2(:)==channel3(:))
                experimentdata.images{m} = experimentdata.images{m}(:,:,1);
            end
        end
    end
end

% load the sounds
if ~isempty(experimentdata.sounds)
    % First we have to initialise the sound
    if ~validating
        InitializePsychSound;
    end
    for k=1:numel(experimentdata.sounds)
        wavFilename = ['stimuli/' experimentdata.sounds{k}];
        if ~exist(wavFilename,'file')
            error('No wav file %s found',wavFilename);
        end
        [wavedata, freq] = wavread(wavFilename);
        wavedata = wavedata';
        nrchannels = size(wavedata,1); % Number of rows == number of channels.
        
        if k==1
            experimentdata.freq = freq;
            experimentdata.nrchannels = nrchannels;
        else
            if experimentdata.freq ~= freq || experimentdata.nrchannels ~= nrchannels
                error('The frequency and number of channels of the wav files must be the same for all the files');
            end
        end
        if ~validating
            experimentdata.audioBuffer(k) = PsychPortAudio('CreateBuffer',[],wavedata);
        end
    end
end

if ~isempty(experimentdata.strings)
    str = experimentdata.strings;
    for m=1:length(str.name)
        experimentdata.texts.(str{m}.name) = str{m}.value;
    end
end