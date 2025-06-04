% RUNEXPERIMENT - run the main part of the experiment
%
% results = runexperiment(e,recordingStimuli,curScreen)
%
% returns a struct with information about how the experiment was run
% (also saved to a file results.mat)
%
% if recordingStimuli=1 (default 0), stimuli will be saved to
% image files (for making movies). This is very slow and should never
% be used with real experiments
%
% curScreen - which screen to use (default 0). With one monitor, 0 is
% the main screen. If there are two monitors, you may need to set this
% to 1 or 2 to use the appropriate monitor

function results = runexperiment(e,recordingStimuli,curScreen)

thedevices = fields(e.devices);
for k=1:length(thedevices)
    if isempty(e.devices.(thedevices{k}))
        error('You need to run setupdevices before running runexperiment, e.g. e = setupdevices(e);');
    end
end

% Read strings, labels, symbols (if they exist)
experimentdata = readResources(e);

if nargin<2 || isempty(recordingStimuli)
    experimentdata.recordingStimuli = 0;
else
    experimentdata.recordingStimuli = recordingStimuli;
end

if nargin<3 || isempty(curScreen)
    curScreen = 0;
end

if experimentdata.recordingStimuli
    if ~exist('screenshots','dir')
        mkdir('screenshots');
    end
end

% make sure we are using openGL
AssertOpenGL;
% make key names same on windows and OSX
KbName('UnifyKeyNames');

% Set text encoding to UTF-8 so that unicode will work (e.g. Hebrew)
Screen('Preference', 'TextEncodingLocale', 'UTF-8');

% Call GetSecs to make sure mex file is loaded
GetSecs;

% Read in the codes used
codes = messagecodes;
experimentdata.screenInfo.bckgnd = 0;

% Prepare staircases if appropriate
experimentdata = prepareStaircase(e,experimentdata,0);

% check if auditory stroop is used and microphone requested
useAudioStroopMicrophone = 0;
for k=1:numel(e.protocol.trial)
    if isfield(e.protocol.trial{k},'audioStroop') && isfield(e.protocol.trial{k}.audioStroop,'recordMicrophone') && ...
        e.protocol.trial{k}.audioStroop.recordMicrophone
            useAudioStroopMicrophone = 1;
        break;
    end
end
    
% Put everything inside a giant "try" so that we can close the screen if it crashes
try
    % Open PsychPortAudio in the right mode (depending on whether there is
    % sound ouput and/or input)
    if ~isempty(experimentdata.sounds) || ~isempty(experimentdata.beeps)
        if useAudioStroopMicrophone==0
            experimentdata.pahandle = PsychPortAudio('Open', [], 1, 0, experimentdata.freq, experimentdata.nrchannels);
        else 
            experimentdata.pahandle = PsychPortAudio('Open', [], 3, 0, experimentdata.freq, experimentdata.nrchannels);
            % Set aside a 10s audio buffer
            PsychPortAudio('GetAudioData', experimentdata.pahandle, 10);
        end
    end
    % Call psychtoolbox to open the screen (can take a while)
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask','General','UseVirtualFramebuffer');
    
    if ~isempty(experimentdata.vr)
        % initialize Matlab OpenGL
        InitializeMatlabOpenGL(0,1);
        fprintf('Stereo mode is %d\n',experimentdata.vr.stereomode);
        [experimentdata.screenInfo.curWindow, experimentdata.screenInfo.screenRect] = PsychImaging('OpenWindow', curScreen, experimentdata.screenInfo.bckgnd,[],32, 2,experimentdata.vr.stereomode);
        % Do OpenGL setup (required once per experiment)
        experimentdata = setupvr(e,experimentdata);
    else
        % Instead of the "usual" version, use PsychImaging to prevent bug in
        % graphics driver / memory leak causing the program to crash
        % (see explanation in http://tech.groups.yahoo.com/group/psychtoolbox/message/11951 )
        [experimentdata.screenInfo.curWindow,experimentdata.screenInfo.screenRect] = PsychImaging('OpenWindow', curScreen, experimentdata.screenInfo.bckgnd,[],32, 2);
    end
    Screen('BlendFunction', experimentdata.screenInfo.curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    %Screen('BlendFunction', experimentdata.screenInfo.curWindow, GL_ONE, GL_ZERO);

    
    writetolog(e,'Opened window');
    
    experimentdata = readVisualResources(e,experimentdata);
    
    % Hide the cursor
    HideCursor;
    
    % Loop through the protocol
    currentTrial=1;
    while currentTrial <= numTrials(e)
        fprintf('Trial %d of %d\n',currentTrial,numTrials(e));
        writetolog(e,sprintf('Trial %d',currentTrial));
        thistrialprotocol = e.protocol.trial{currentTrial};
        
        % Each "trial" has four stages (note that some of them may do nothing for some types of trials)
        %
        % 1. Setting up - set up all variables, prepare optotrak, etc
        % 2. Wait to start the event, at this point you can optionally go back or forward or quit
        % 3. Do that actual event
        % 4. Give feedback
        
        % STAGE 1 - setup the trial
        thistrial = readTrialParameters(e,thistrialprotocol,experimentdata);
        writetolog(e,'Read trial parameters');
        thistrialrecording = thistrial.recording;
        thistrial.trialnum = currentTrial;
        
        % setup the DRT if it is used
        if ~isempty(thistrial.DRT)
           thistrial = setupDRT(thistrial,experimentdata);
        end
        
        % setup the audio stroop if it is used
        if ~isempty(thistrial.audioStroop)
           thistrial = setupAudioStroop(thistrial,experimentdata);
        end

        % run the appropriate trial setup for this type of stimulus
        thistrial = setup(thistrial.thisstimulus,e,thistrial,experimentdata);
        writetolog(e,'Setup stimulus');
        
        if ~isnan(thistrialrecording)
            thistrial.recording = thistrialrecording;
        elseif isnan(thistrial.recording)
            thistrial.recording = 1;
        end
        
        if thistrial.recording && isempty(thistrial.filename)
            error('A filename must be specified when recording');
        end
        
        % This may be changed below
        thistrial.sampleWhenNotRecording=0;
        
        % Make any necessary changes to thistrial for the response (e.g. setting thistrial.sampleWhenNotRecording)
        thistrial = setup(thistrial.thisresponse,thistrial);
        
        % Make any necessary changes to thistrial for the start
        thistrial = setup(thistrial.thisstarttrial,thistrial);
        writetolog(e,'Ran starttrial setup');
        
        % Setup the recording devices, if appropriate
        if thistrial.recording
            e = setupRecording(e,[e.resultDir '/' thistrial.filename],thistrial.recordingTime + 5,experimentdata.screenInfo.curWindow);
        end
        
        % Draw the background
        if ~isempty(experimentdata.vr) && experimentdata.vr.stereomode>0
            for k=[1 0]
                Screen('SelectStereoDrawBuffer', experimentdata.screenInfo.curWindow, k);
                Screen(experimentdata.screenInfo.curWindow,'FillRect',thistrial.backgroundColor);
            end
        else
            Screen(experimentdata.screenInfo.curWindow,'FillRect',thistrial.backgroundColor);
        end
        
        % Run any actions before the trial starts. This is used for stimuli that just show something for an infinite
        % amount of  time until a key is pressed (e.g. showText or showImage)
        
        preStart(thistrial.thisstimulus,experimentdata,thistrial,1);
        DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,1);
        writetolog(e,'Ran prestart');
        
        % STAGE 2 - wait for start of trial (determined by starttrial)
        
        % In all cases, the keyboard should be checked (value return in keyCode) to allow quitting the program between trials
        
        
        % Do the actual waiting.
        % If we need to show the position, we need to turn on sampling (but not record yet)
        startedSamplingWithoutRecording = 0;
        if thistrial.showPosition || thistrial.sampleWhenNotRecording
            thistrial = startSamplingWithoutRecording(e,thistrial,experimentdata);
            startedSamplingWithoutRecording = 1;
        end
        started = 0;
        thistrial.lastposition = [];
        thistrial.lastpositionVisual = [];
        while started~=1
            [started,keyCode,thistrial] = hasStarted(thistrial.thisstarttrial,e,experimentdata,thistrial);
            if thistrial.showPosition
                thistrial.lastposition = [];
                thistrial.lastpositionVisual = [];
                preStart(thistrial.thisstimulus,experimentdata,thistrial,0);
                DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,0);
                [thistrial.lastposition,thistrial, experimentdata] = showPosition(e,thistrial,experimentdata,-1);
                Screen('Flip',experimentdata.screenInfo.curWindow,1);
                % If the background is not white, then draw it
                if ~all(thistrial.backgroundColor==0)
                    Screen(experimentdata.screenInfo.curWindow,'FillRect',thistrial.backgroundColor);
                end
                if ~isempty(thistrial.backgroundImage)
                    Screen('DrawTexture',experimentdata.screenInfo.curWindow,experimentdata.textures(thistrial.backgroundImage));
                end

            end
            if any(keyCode) && any(find(keyCode,1)==[KbName('n') KbName('p') KbName('q')])  % n, p or q
                if thistrial.showPosition || thistrial.sampleWhenNotRecording
                    stopRecording(e);
                end
                % stop this trial, will be dealt with outside this loop
                
                % Wait for them to let go of the key
                while KbCheck(-1)
                    %
                end
                break;
            end
        end
        % If the trial has recordingTime of 0 (i.e. just show something), then make sure they have left the key
        % before continuing
        thistrial.starttime = GetSecs;
        writetolog(e,'Start condition met');

        if thistrial.recordingTime==0
            alreadyshown = 0;
            while hasStarted(thistrial.thisstarttrial,e,experimentdata,thistrial)==1
                % wait for them to release the button
                if ~alreadyshown
                    writetolog(e,'Waiting for button / key to be release to start recordingTime==0 trial');
                    alreadyshown = 1;
                end
            end
            if alreadyshown
                writetolog(e,'Button released');
            end
        end
        
        % Check if keypress is 'q' to quit, 'n' to skip to next event, 'p' for previous event
        % (otherwise ignore)
        
        if find(keyCode)==KbName('n') % n = skip to next event
            currentTrial = currentTrial + 1;
            results.thistrial{currentTrial} = thistrial;
            writetolog(e,'Pressed n, skipping to next event');
            continue;
        elseif find(keyCode)==KbName('p') % p = go back to previous event
            if currentTrial>1
                currentTrial = currentTrial-1;
                writetolog(e,'Pressed p, going back to previous event');
                continue;
            end
        elseif find(keyCode)==KbName('q') % q = quit
            currentTrial = inf;
            writetolog(e,'Pressed q, quitting');
            continue;
        end
        
        % Otherwise, continue!
        
        % STAGE 3- do the actual event
        % setup any triggers for later (e.g. for triggering EMG recordings, or TMS pulses)
        thistrial = setupTrigger(thistrial);
        
        % setup any beeps
        thistrial = setupBeeps(thistrial,experimentdata);
        
        % setup any tactor stimulations
        thistrial = setupTactors(thistrial);
        
        DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,0);

        % Show the position (e.g. mouse, cursor) if appropriate
        if thistrial.showPosition
            preStart(thistrial.thisstimulus,experimentdata,thistrial,0);
            [thistrial.lastposition,thistrial, experimentdata] = showPosition(e,thistrial,experimentdata,-1);
        end
        Screen('Flip',experimentdata.screenInfo.curWindow,1);
        % If the background is not white, then draw it
        if ~all(thistrial.backgroundColor==0)
            Screen(experimentdata.screenInfo.curWindow,'FillRect',thistrial.backgroundColor);
        end
        if ~isempty(thistrial.backgroundImage)
            Screen('DrawTexture',experimentdata.screenInfo.curWindow,experimentdata.textures(thistrial.backgroundImage));
        end

      
        % Start recording with the devices
        if thistrial.recording
            startRecording(e,thistrial.filename,thistrial.recordingTime + 2);
        elseif thistrial.sampleWhenNotRecording && startedSamplingWithoutRecording==0
            startSamplingWithoutRecording(e,thistrial,experimentdata);
            startedSamplingWithoutRecording=1;
        end
        if thistrial.showPosition
            thistrial.lastx = []; thistrial.lasty = [];
        end
        
        
        if thistrial.waitTimeBefore > 0
            % Draw a fixation point, if appropriate
            if thistrial.drawFixation
                drawFixation(experimentdata);
            end
            DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,0);
            if thistrial.showPosition
                [thistrial.lastposition,thistrial] = showPosition(e,thistrial,experimentdata,-1);
            end
            Screen('Flip',experimentdata.screenInfo.curWindow,1);
            % If the background is not white, then draw it
            if ~all(thistrial.backgroundColor==0)
                Screen(experimentdata.screenInfo.curWindow,'FillRect',thistrial.backgroundColor);
            end
            if ~isempty(thistrial.backgroundImage)
                    Screen('DrawTexture',experimentdata.screenInfo.curWindow,experimentdata.textures(thistrial.backgroundImage));
            end
            aborted=0;
            startFixation = GetSecs;
            while(GetSecs<startFixation+thistrial.waitTimeBefore)
                thistrial.lastposition = [];
                thistrial.lastpositionVisual = [];
                % In the button press cases, they should be still pressing
                % the button, otherwise abort and repeat the trial
                % (because the stimuli has not yet been shown)
                if ~stillAtStart(thistrial.thisstarttrial,e,experimentdata,thistrial)
                    responseText = experimentdata.texts.TOO_EARLY;
                    drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,responseText);
                    writetolog(e,sprintf('Wrote text when not still at start %s',responseText));
                    if thistrial.recording || thistrial.sampleWhenNotRecording || thistrial.showPosition
                        stopRecording(e);
                    end
                    playAnnoyingBeep(experimentdata);
                    WaitSecs(2);
                    DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,1);
                    aborted=1;
                    thistrial.aborted=1;
                    break;
                end
                if thistrial.drawFixation
                    drawFixation(experimentdata);
                end
                DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,0);
                if thistrial.showPosition
                    [thistrial.lastposition,thistrial] = showPosition(e,thistrial,experimentdata,-1);
                end
                Screen('Flip',experimentdata.screenInfo.curWindow,1);
                % If the background is not white, then draw it
                if ~all(thistrial.backgroundColor==0)
                    Screen(experimentdata.screenInfo.curWindow,'FillRect',thistrial.backgroundColor);
                end
                if ~isempty(thistrial.backgroundImage)
                    Screen('DrawTexture',experimentdata.screenInfo.curWindow,experimentdata.textures(thistrial.backgroundImage));
                end
            end
            if aborted
                continue;
            end
        end
        
        if isnan(experimentdata.framerate)
            thistrial.numFrames = round((thistrial.recordingTime - thistrial.waitTimeBefore)*experimentdata.screenInfo.monRefresh);
        else
            thistrial.numFrames = round((thistrial.recordingTime - thistrial.waitTimeBefore)*experimentdata.framerate);
        end
        if thistrial.numFrames < inf
            thistrial.frameInfo.startFrame = NaN * ones(thistrial.numFrames,1);
        end
        
        % run the appropriate start of trial setup. These files (e.g. startEvent.m) should be in the appropriate directories if
        % needed. For most stimuli types, it is not needed, and so the default (from @stimulus) will be run which does nothing
        [thistrial,experimentdata] = startEvent(thistrial.thisstimulus,thistrial,experimentdata,codes);
        thistrial.needToStopAudio = 0;
        if numel(thistrial.beeped) && isnan(thistrial.beeped(1))
            PsychPortAudio('Start', experimentdata.pahandle, [], GetSecs);
            writetolog(e,'Started preprogrammed beeps');
            thistrial.beeped = []; % This has triggered all the beeps for the trial
            thistrial.needToStopAudio = 1;
        end
        
        abortTrial=0;
        for frame = 1:min(thistrial.numFrames,10^8)
            thistrial.frameInfo.startFrame(frame) = GetSecs;
            thistrial.lastposition = [];
            thistrial.lastpositionVisual = [];
            if frame>1
                thisFrameTime = thistrial.frameInfo.startFrame(frame) - thistrial.frameInfo.startFrame(1);
            else
                thisFrameTime = 0;
                if thistrial.recording
                    markEvent(e,codes.firstFrame);
                end
            end
            if frame==thistrial.stimuliFrames
                if thistrial.recording
                    markEvent(e,codes.lastFrame);
                end
            end
            % send pulse at the appropriate time
            thistrial = checkTriggers(e,thistrial,thisFrameTime,experimentdata);
            
            % beep if appropriate
            if any(~thistrial.beeped)
                for m=1:numel(thistrial.beep)
                    if ~thistrial.beeped(m) && thisFrameTime > thistrial.beep{m}.time
                        if thistrial.recording
                            markEvent(e,codes.beeped);
                        end
                        beep;
                        thistrial.beeped(m) = 1;
                    end
                end
            end
            
            % send tactor stimuli if appropriate
            if any(~thistrial.tactored)
                for m=1:numel(thistrial.tactor)
                    if ~thistrial.tactored(m) && thisFrameTime > thistrial.tactor{m}.time
                        if thistrial.recording
                            markEvent(e,codes.tactored+thistrial.tactor{m}.sequenceNumber);
                        end
                        writetolog(e,'Sent tactor stimuli');
                        playSequence(experimentdata.tactors,thistrial.tactor{m}.sequenceNumber);
                        writetolog(e,'Finished sending tactor stimuli');
                        thistrial.tactored(m) = 1;
                    end
                end
            end
            
            % play a sound if appropriate
            for m=1:numel(thistrial.playAudioFile)
                if ~thistrial.playAudioFile{m}.started && thisFrameTime > thistrial.playAudioFile{m}.starttime
                    PsychPortAudio('FillBuffer',experimentdata.pahandle,experimentdata.audioBuffer(thistrial.playAudioFile{m}.number));
                    startTime = PsychPortAudio('Start', experimentdata.pahandle, [], 0, 0);
                    thistrial.playAudioFile{m}.started = GetSecs;
                    writetolog(e,sprintf('Started audio at %f',startTime));
                    markEvent(e,codes.soundPlayed);
                    thistrial.needToStopAudio = 1;
                end
            end
            
            if ~isempty(thistrial.DRT)
                [keyIsDown, ~, keyCode] = KbCheck(-1);
                if thistrial.DRT.state==2
                    % do nothing, finished for this trial
                elseif thistrial.DRT.state==0 && thisFrameTime > thistrial.DRT.nextDRTonset(end)
                    % play the beep
                    PsychPortAudio('Start',experimentdata.pahandle,0,0,0);
                    writetolog(e,sprintf('Started DRT beep at %.3f',thisFrameTime));
                    markEvent(e,codes.DRTstart);
                    thistrial.needToStopAudio = 1;
                    thistrial.DRT.state = 1;
                elseif thistrial.DRT.state==1 && keyIsDown && strcmp(KbName(keyCode),thistrial.DRT.keyToPress)
                    PsychPortAudio('Stop',experimentdata.pahandle,0,0);
                    writetolog(e,sprintf('Stopped DRT beep at %.3f',thisFrameTime));
                    markEvent(e,codes.DRTpressed);
                    thistrial.DRT.state = 0;
                    % Set the time for the next trial
                    offset = (thistrial.DRT.maxTimeBetween - thistrial.DRT.minTimeBetween) * rand + ...
                        thistrial.DRT.minTimeBetween;
                    nextonset = thisFrameTime + offset;
                    if nextonset > thistrial.DRT.endtime
                        thistrial.DRT.state = 2;
                    else
                        thistrial.DRT.nextDRTonset(end+1) = nextonset;
                    end
                elseif thistrial.DRT.state==1 && thisFrameTime > thistrial.DRT.nextDRTonset(end) + thistrial.DRT.toneMaxDuration
                    PsychPortAudio('Stop',experimentdata.pahandle,0,0);
                    writetolog(e,sprintf('Stopped DRT beep on timeout at %.3f',thisFrameTime));
                    markEvent(e,codes.DRTtimeout);
                    thistrial.DRT.state = 0;
                    % As this was a timeout, finish the trial, then set the
                    % time for the next trial
                    offset = (thistrial.DRT.maxTimeBetween - thistrial.DRT.minTimeBetween) * rand + ...
                        thistrial.DRT.minTimeBetween + thistrial.DRT.trialEndNoResponse;
                    nextonset = thistrial.DRT.nextDRTonset(end) + offset;
                    if nextonset > thistrial.DRT.endtime
                        thistrial.DRT.state = 2;
                    else
                        thistrial.DRT.nextDRTonset(end+1) = nextonset;
                    end
                end
            end
            
            if ~isempty(thistrial.audioStroop)
                [keyIsDown, ~, keyCode] = KbCheck(-1);
                if thistrial.audioStroop.state==2
                    % do nothing, finished for this trial
                elseif thistrial.audioStroop.state==0 && thisFrameTime > thistrial.audioStroop.nextaudioStrooponset(end)
                    % play the beep
                    nextNumber = ceil(rand*thistrial.audioStroop.numStimuli);
                    if thistrial.audioStroop.type==1
                        PsychPortAudio('FillBuffer', experimentdata.pahandle,experimentdata.beepbuffer{thistrial.audioStroop.numbers(nextNumber)});
                    else
                        PsychPortAudio('FillBuffer',experimentdata.pahandle,experimentdata.audioBuffer(thistrial.audioStroop.numbers(nextNumber)));
                    end
                    PsychPortAudio('Start',experimentdata.pahandle,1,0,0);
                    writetolog(e,sprintf('Started audioStroop sound %d at %.3f',nextNumber,thisFrameTime));
                    markEvent(e,codes.(['audioStroopstart' num2str(nextNumber)]));
                    thistrial.needToStopAudio = 1;
                    thistrial.audioStroop.state = 1;
                elseif thistrial.audioStroop.state==1 && keyIsDown && any(strfind(thistrial.audioStroop.keysToPress,KbName(keyCode)))
                    writetolog(e,sprintf('audioStroop pedal pressed at %.3f',thisFrameTime));
                    PsychPortAudio('Stop',experimentdata.pahandle,0,0);
                    if strcmp(thistrial.audioStroop.keysToPress(1),KbName(keyCode))
                        markEvent(e,codes.audioStroop1pressed);
                    elseif strcmp(thistrial.audioStroop.keysToPress(2),KbName(keyCode))
                        markEvent(e,codes.audioStroop2pressed);                    
                    end
                    thistrial.audioStroop.state = 0;
                    % Set the time for the next trial
                    offset = (thistrial.audioStroop.maxTimeBetween - thistrial.audioStroop.minTimeBetween) * rand + ...
                        thistrial.audioStroop.minTimeBetween;
                    nextonset = thisFrameTime + offset;
                    if nextonset > thistrial.audioStroop.endtime
                        thistrial.audioStroop.state = 2;
                    else
                        thistrial.audioStroop.nextaudioStrooponset(end+1) = nextonset;
                    end
                elseif thistrial.audioStroop.state==1 && thisFrameTime > thistrial.audioStroop.nextaudioStrooponset(end) + thistrial.audioStroop.trialEndNoResponse
                    writetolog(e,sprintf('audioStroop timeout at %.3f',thisFrameTime));
                    PsychPortAudio('Stop',experimentdata.pahandle,0,0);
                    % write to a file
                    if thistrial.audioStroop.recordMicrophone
                        audiodata = PsychPortAudio('GetAudioData', experimentdata.pahandle);
                        if isfield(thistrial,'filename') && thistrial.recording
                            if ~exist('wavcounter','var')
                                wavcounter = 1;
                            else
                                wavcounter = wavcounter + 1;
                            end
                            wavfilename = sprintf('%s/%s_%03d.wav',e.resultDir,thistrial.filename,wavcounter);
                            audiowrite(wavfilename,transpose(audiodata), 44100);
                        end
                    end
                    markEvent(e,codes.audioStrooptimeout);
                    thistrial.audioStroop.state = 0;
                    % As this was a timeout, finish the trial, then set the
                    % time for the next trial
                    offset = (thistrial.audioStroop.maxTimeBetween - thistrial.audioStroop.minTimeBetween) * rand + ...
                        thistrial.audioStroop.minTimeBetween + thistrial.audioStroop.trialEndNoResponse;
                    nextonset = thistrial.audioStroop.nextaudioStrooponset(end) + offset;
                    if nextonset > thistrial.audioStroop.endtime
                        thistrial.audioStroop.state = 2;
                    else
                        thistrial.audioStroop.nextaudioStrooponset(end+1) = nextonset;
                    end
                end
            end
            % Check if they have started moving already
            if thistrial.checkMoving && thisFrameTime >= thistrial.checkMoving
                % If they are still pressing the button, abort
                if stillPressing(thistrial.thisstarttrial,e,experimentdata,thistrial)==1
                    DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,0);
                    responseText = experimentdata.texts.TOO_LATE;
                    drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,responseText,[],[],thistrial.textFeedbackColor);
                    writetolog(e,sprintf('Wrote text in checkMoving %s',responseText));
                    playAnnoyingBeep(experimentdata);
                    WaitSecs(1);
                    DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,1);
                    abortTrial = 1;
                    break;
                else
                    % don't check again this trial
                    thistrial.checkMoving=0;
                end
            end
            
            thistrial.pressure = 1; % set default tablet pressure to 1
            
            if frame <= thistrial.stimuliFrames
                % Present a frame
                DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,0);
                % run the appropriate trial. This files (e.g. frame.m) should be in e.g. @videostimulus
                % If the file is absent, the default from @stimulus will be used (which does nothing)
                [thistrial,experimentdata,breakfromloop,thistrial.thisstimulus] = displayFrame(thistrial.thisstimulus,e,frame,thistrial,experimentdata);
                if thistrial.showPosition
                    [thistrial.lastposition,thistrial,experimentdata] = showPosition(e,thistrial,experimentdata,frame);
                end
                
                if breakfromloop
                    break;
                end
                
                % if a framerate has been set, set the next flip to
                % be at the appropriate time (otherwise, as fast as possible)
                if ~isnan(experimentdata.framerate) && frame > 1
                    % Set it to 90% of the time (it needs to be slightly before the desired time)
                    nextflip = thistrial.VBLTimestamp(frame-1) + 0.9 * (1/experimentdata.framerate);
                else
                    nextflip = 0;
                end
                
                [thistrial.VBLTimestamp(frame), thistrial.StimulusOnsetTime(frame), ...
                    thistrial.FlipTimestamp(frame), thistrial.Missed(frame), ...
                    thistrial.Beampos(frame)] = ...
                    Screen('Flip',experimentdata.screenInfo.curWindow,nextflip,thistrial.dontclear);
                % If the background is not white, then draw it
                if ~all(thistrial.backgroundColor==0)
                    Screen(experimentdata.screenInfo.curWindow,'FillRect',thistrial.backgroundColor);
                end
                if ~isempty(thistrial.backgroundImage)
                    Screen('DrawTexture',experimentdata.screenInfo.curWindow,experimentdata.textures(thistrial.backgroundImage));
                end
            else
                % Pass time until the end of the trial (so there will be the right number of frames)
                DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,0);
                if thistrial.showPosition
                    [thistrial.lastposition,thistrial] = showPosition(e,thistrial,experimentdata,frame);
                end
                Screen('Flip',experimentdata.screenInfo.curWindow,0,thistrial.dontclear);
                % If the background is not white, then draw it
                if ~all(thistrial.backgroundColor==0)
                    Screen(experimentdata.screenInfo.curWindow,'FillRect',thistrial.backgroundColor);
                end
                if ~isempty(thistrial.backgroundImage)
                    Screen('DrawTexture',experimentdata.screenInfo.curWindow,experimentdata.textures(thistrial.backgroundImage));
                end
            end
            if thistrial.checkMovingAfter && thisFrameTime <= thistrial.checkMovingAfter
                if stillPressing(thistrial.thisstarttrial,e,experimentdata,thistrial)==0
                    DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,0);
                    if thistrial.textFeedback~=-1
                        responseText = experimentdata.texts.TOO_EARLY;
                        drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,responseText,[],[],thistrial.textFeedbackColor);
                        writetolog(e,sprintf('Wrote text in checkMovingAfter %s',responseText));
                    end
                    if thistrial.auditoryFeedback
                        playAnnoyingBeep(experimentdata);
                        WaitSecs(1);
                    end
                    DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,1);
                    abortTrial = 1;
                    break;
                end
            end
            if ~isempty(thistrial.checkMovingForward) && thisFrameTime >= thistrial.checkMovingForward.time(1) 
                if ~isempty(thistrial.lastposition)
                    [toAbort,thistrial] = checkMovingForward(e,thistrial,experimentdata,thistrial.lastposition);
                else
                    [toAbort,thistrial] = checkMovingForward(e,thistrial,experimentdata);
                end
                if toAbort
                    DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,0);
                    responseText = experimentdata.texts.NOT_MOVING_FORWARD;
                    drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,responseText,[],[],thistrial.textFeedbackColor);
                    writetolog(e,sprintf('Wrote text in checkMovingForward %s',responseText));
                    playAnnoyingBeep(experimentdata);
                    WaitSecs(1);
                    DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,1);
                    abortTrial = 1;
                    break;
                end
            end
            % check if the trial should be ended
            if ~isempty(thistrial.lastposition)
                [tofinish,thistrial,experimentdata] = finishTrial(thistrial.thisresponse,thistrial,experimentdata,e,thistrial.lastposition,frame);
            else
                [tofinish,thistrial,experimentdata] = finishTrial(thistrial.thisresponse,thistrial,experimentdata,e,[],frame);
            end
            if tofinish
                thistrial.finishtime = GetSecs;
                break;
            end
        end
        if thistrial.needToStopAudio
            PsychPortAudio('Stop',experimentdata.pahandle);
        end
        if abortTrial
            DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,1);
            % Stop recording
            if thistrial.recording || thistrial.sampleWhenNotRecording || thistrial.showPosition
                stopRecording(e);
                % Start sampling again without recording to make sure they
                % are not still pressing
                thistrial = startSamplingWithoutRecording(e,thistrial,experimentdata);
            end
            while stillPressing(thistrial.thisstarttrial,e,experimentdata,thistrial)==1
                %    ; % wait for them to release the button
            end
            if thistrial.recording || thistrial.sampleWhenNotRecording || thistrial.showPosition
                stopRecording(e);
                finishRecordingTrial(e);    
            end
            if experimentdata.incrementOnAbort
                results.thistrial{currentTrial} = thistrial;
                currentTrial = currentTrial+1;
                writetolog(e,'Trial aborted, skipping to next trial');
            else
                writetolog(e,'Trial aborted, repeating trial');
            end            
            continue;
        end
        % Clear the screen
        DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,0);
        
        % Stop recording
        % Save the file later (after feedback) because it can be slow
        if thistrial.recording || thistrial.sampleWhenNotRecording || thistrial.showPosition
            stopRecording(e);
            finishRecordingTrial(e);
        end
        if thistrial.recording
            dataSummary = getDataSummary(e);
        else
            dataSummary = NaN;
        end
        % Give feedback
        if currentTrial>1
            thistrial = feedback(thistrial.thisresponse,e,thistrial,results.thistrial{currentTrial-1},experimentdata,dataSummary,results);
        else
            thistrial = feedback(thistrial.thisresponse,e,thistrial,[],experimentdata,dataSummary);
        end
        
        DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,0);
        
        if thistrial.textFeedback==1 && isfield(thistrial,'imageFeedback') && ~isempty(thistrial.imageFeedback)
            feedbackTexture = Screen('MakeTexture',experimentdata.screenInfo.curWindow,...
                experimentdata.images{thistrial.imageFeedback});
            Screen('DrawTexture',experimentdata.screenInfo.curWindow,feedbackTexture);
            Screen('Flip',experimentdata.screenInfo.curWindow,1);
            WaitSecs(1);
            writetolog(e,sprintf('Show image %d as feedback',thistrial.imageFeedback));
        elseif thistrial.textFeedback==1 && isfield(thistrial,'responseText')
            if ~thistrial.textFeedbackShowBackground
                Screen('Flip',experimentdata.screenInfo.curWindow,0,0);
                % If the background is not white, then draw it
                if ~all(thistrial.backgroundColor==0)
                    Screen(experimentdata.screenInfo.curWindow,'FillRect',thistrial.backgroundColor);
                end
            end
            drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,thistrial.responseText,[],[],thistrial.textFeedbackColor);
            WaitSecs(1);
            writetolog(e,sprintf('Wrote text %s',thistrial.responseText));
        end
        if thistrial.playsound && thistrial.auditoryFeedback
            playAnnoyingBeep(experimentdata);
            WaitSecs(2);
        end
        
        experimentdata = updateStaircase(e,experimentdata,thistrial);
        
        DrawBackground(experimentdata,thistrial,experimentdata.boxes,experimentdata.labels,0);
        
        % Save the file
        if isfield(thistrial,'filename') && thistrial.recording
            saveFile(e);
        end
        % Save thistrial
        results.thistrial{currentTrial} = thistrial;
        if isfield(thistrial,'successful')
            experimentdata.successful(currentTrial) = thistrial.successful;
        end
        if isfield(thistrial,'hitTarget')
            experimentdata.hitTarget(currentTrial) = thistrial.hitTarget;
        end
        if isstruct(dataSummary) && isfield(dataSummary,'RT')
            % include some other useful data
            thistrial.RT = dataSummary.RT;
            experimentdata.RTs(currentTrial) = dataSummary.RT;
        elseif isstruct(dataSummary) && isfield(dataSummary,'kb_RT')
            thistrial.RT = dataSummary.kb_RT;
            experimentdata.RTs(currentTrial) = dataSummary.kb_RT;
        elseif isstruct(dataSummary) && isfield(dataSummary,'filename')
            experimentdata.filename{currentTrial} = dataSummary.filename;
        end
        if isfield(thistrial,'percentCoherent')
            experimentdata.percentCoherents(currentTrial) = str2double(thistrial.percentCoherent);
        end
        if isfield(thistrial,'noiseVar')
            experimentdata.noiseLevels(currentTrial) = noiseVar;
        end
        if ~isempty(thistrial.filename)
            trialinfofilename = [e.resultDir '/trialinfo_' thistrial.filename '.mat'];
            save(trialinfofilename,'thistrial');
            writetolog(e,sprintf('Saved dot/frame data to file %s',trialinfofilename));
        end
        
        % Check that the recording was OK
        if thistrial.recording && thistrial.checkRecording
            checkRecording(e,dataSummary,experimentdata,thistrial);
        end
        
        % any post-trial cleanup for the stimulus
        [thistrial,experimentdata] = postTrial(thistrial.thisstimulus,dataSummary,thistrial,experimentdata,e);
        writetolog(e,'Ran post-trial');
        % close feedback images if there were used
        if exist('feedbackTexture','var')
             Screen('Close',feedbackTexture);
             clear feedbackTexture;
        end
        
        % Write screenshots to disk, if appropriate
        if experimentdata.recordingStimuli
            for k=1:length(thistrial.imageArray)
                imwrite(thistrial.imageArray{k},sprintf('screenshots/trial%03dframe%03d.jpg',currentTrial,k));
            end
        end
        
        currentTrial = currentTrial+1;
        
        % If they are pressing the 'q' key, then quit
        [~,~,keyCode] = KbCheck(-1);
        if find(keyCode,1)==KbName('q') % q = quit
            currentTrial = inf;
            writetolog(e,'Pressed q, quitting');
            continue;
        end
    end
    if isfield(experimentdata,'textures')
        Screen('Close',experimentdata.textures);
    end
    % Set the screen back to normal
    closescreen;
    if exist('experimentdata','var')
        results.experimentdata = experimentdata;
        % If there are staircases, save them in a separate file
        if isfield(experimentdata,'staircases') && ~isempty(experimentdata.staircases)
            staircases = experimentdata.staircases;
            save([e.resultDir '/staircases.mat'],'staircases');
        end
    end
    % Save the overall results struct
    if exist('results','var')
        resultfilename = [e.resultDir '/results.mat'];
        save(resultfilename,'-v7.3','results');
        writetolog(e,sprintf('Saved result data to file %s',resultfilename));
    else
        results = [];
    end
    if ~isempty(experimentdata.tactors)
        close(experimentdata.tactors);
    end
    if ~isempty(experimentdata.serial)
        close(experimentdata.serial);
    end
    if ~isempty(experimentdata.sounds) || ~isempty(experimentdata.beeps)
        PsychPortAudio('Close');
    end
    % close the devices + log file
    closedevices(e);
catch err
    fprintf('Caught an error\n');
    fprintf('Error caught on line %d in %s: \n %s \n',err.stack(1).line,err.stack(1).file,err.message);
    
    % save current data
    if exist('experimentdata','var')
        results.experimentdata = experimentdata;
        % If there are staircases, save them in a separate file
        if isfield(experimentdata,'staircases') && ~isempty(experimentdata.staircases)
            staircases = experimentdata.staircases;
            save([e.resultDir '/staircases.mat'],'staircases');
        end
    end
    % Save the overall results struct
    resultfilename = [e.resultDir '/results.mat'];
    if exist('results','var')
        save(resultfilename,'-v7.3','results');
        writetolog(e,sprintf('Saved result data to file %s',resultfilename));
    else
        writetolog(e,sprintf('No variable results to write to file'));
    end
    if isfield(experimentdata,'textures')
        Screen('Close',experimentdata.textures);
    end
    closescreen;
    if ~isempty(experimentdata.tactors)
        close(experimentdata.tactors);
    end
    if ~isempty(experimentdata.serial)
        close(experimentdata.serial);
    end
    % close the devices + log file
    closedevices(e);
end

