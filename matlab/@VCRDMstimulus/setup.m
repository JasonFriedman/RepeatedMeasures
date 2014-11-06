% SETUP - Prepare a "VCRDM" trial (random dots)
% Do not call directly, will be called by runexperiment
%
% Based on the VCRDM code written by Maria Mckinley, available from
% http://www.shadlenlab.columbia.edu/Code/VCRDM

function thistrial = setup(s,e,thistrial,experimentdata)

    % Copy over the relevant info
    dotInfo.numDotField = 1; %s.numFrames; % how many frames to show
    dotInfo.apXYD = [experimentdata.xshift 0 s.aperture*10]; %first number is shift in x, second shift in y (both from center)
                                                 %third number is apeture (50 =  5 degrees)
    if ~isnan(thistrial.staircaseNum)
        % Get the coherence to test from quest
        tTest=getStaircaseValue(experimentdata.staircases{thistrial.staircaseNum});
        thistrial.coherence = exp(tTest);
        % FIX ME (make exp / log an option)
        if thistrial.coherence < 0
            thistrial.coherence = 0;
        elseif thistrial.coherence>1
            thistrial.coherence = 1;
        end
        writetolog(e,sprintf('Setting coherence from quest to %.2f',thistrial.coherence));
    else
        if ~isempty(s.percentCoherent)
            thistrial.coherence = s.percentCoherent / 100;
        elseif ~isempty(s.percentAccurate)
            % Get the coherence from the psychophysical function
            % esimated by QUEST
            q = get(experimentdata.staircases{thistrial.staircaseNum},'q');
            q.pThreshold = thistrial.percentAccurate/100;
            q = QuestRecompute(q{1});
            thistrial.coherence = exp(QuestMean(q{1}));
            writetolog(e,sprintf('Setting coherence from quest for %d percent accurate to %.2f',...
                                 str2double(thistrial.percentAccurate),thistrial.coherence));
        else
            error(['For random dots, there has to be either a quest, ' ...
                   'percentCoherent, or percentAccurate field']);
        end
    end
    dotInfo.coh = thistrial.coherence * 1000; % coherence (0 = none ... 1000 = all same)
    dotInfo.speed = s.speed * 10;
    dotInfo.dir = s.direction; % 0 = L to R, 90 = D to U, 180 = R to L, 270 = U to D
    dotInfo.dotColor = 255; % white dots
    dotInfo.dotSize = 2; % dot size in pixels
    dotInfo.trialtype = [1 1]; %fixed time
%    dotInfo.maxDotTime = str2double(thistrial.viewingTime) / 1000; % seconds
    
    % dotInfo.auto
    % column 1: 1 to set manually, 2 to use fixation as center point, 3 to use aperture
    % as center
    % column 2: 1 to set coherence manually, 2 random, 3 correction mode
    % column 3: 1 to set direction manually, 2 random
    %dotInfo.auto = [3 2 2];
    dotInfo.maxDotsPerFrame = 150;   % by trial and error.  Depends on graphics card
    
    % Prepare the dots (if the viewing time is >0)
    
    if s.numFrames > 0
        dotInfo = preparedots(experimentdata.screenInfo,dotInfo);
        writetolog(e,'Set up dots');
    end
    thistrial.dotInfo = dotInfo;
                    
    thistrial.stimuliFrames = s.numFrames+s.firstframe-1;
