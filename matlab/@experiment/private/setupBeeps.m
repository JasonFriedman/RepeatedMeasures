% SETUPBEEPS - setup any beeps

function thistrial = setupBeeps(thistrial,experimentdata)

if ~isempty(thistrial.beep)
    if thistrial.beep{1}.beepNumber ==0 % beepNumber = 0 -> use system beeps
        thistrial.beeped = zeros(length(thistrial.beep),1);
        if ~iscell(thistrial.beep)
            beeptmp = thistrial.beep;
            thistrial = rmfield(thistrial,'beep');
            thistrial.beep{1} = beeptmp;
        end
    else
        % Otherwise, use PsychPortAudio to beep (can then set the frequency / duration)
        % Setup beeps for psychtoolbox
        PsychPortAudio('UseSchedule',experimentdata.pahandle,2); % 2 = Reset schedule
        for k=1:numel(thistrial.beep)
            % Add the beep
            if k==1
                lastBeepTime = 0;
            else
                lastBeepTime = thistrial.beep{k-1}.time;
            end
            delayCmd = -(1+8); % indicate to pause relative to the last requested start time of playback
            PsychPortAudio('AddToSchedule', experimentdata.pahandle, delayCmd, thistrial.beep{k}.time-lastBeepTime);
            PsychPortAudio('AddToSchedule', experimentdata.pahandle, experimentdata.beepbuffer{thistrial.beep{k}.beepNumber});
        end
        thistrial.beeped = NaN;
    end
else
    thistrial.beeped = [];
end

