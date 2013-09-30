% SETUP - Prepare a "images" trial
% Do not call directly, will be called by runexperiment

function thistrial = setup(s,e,thistrial,experimentdata)

thistrial.stimuli = s.stimuli;
thistrial.endtiming = thistrial.stimuli(:,3);
thistrial.starttiming = thistrial.stimuli(:,2);
thistrial.addnoise = thistrial.stimuli(:,4); % this column contains whether
% to add noise.
% 0 = no noise
% positive values = amount of noise
% negative values = percent accurate (using quest)

% start in state 1
if ~isempty(s.stateTransitions)
    thistrial.imageState = 1;
    thistrial.stateSwitchTime = GetSecs;
end

if ~isfield(thistrial,'movementOnsetType')
    % default value
    thistrial.movementOnsetType = 1;
end

for k=1:length(thistrial.starttiming)
    thistrial.trialimages{k} = experimentdata.images{thistrial.stimuli(k,1)};
    thistrial.trialalpha{k} = experimentdata.alpha{thistrial.stimuli(k,1)};
    if thistrial.addnoise(k) ~= 0 % 0 = no noise, positive = amount of noise, negative = percent accurate
        if length(size(thistrial.trialimages{k}))>2
            error('Cannot add noise to color images (only grayscale)');
        end
        if isfield(thistrial,'quest') && str2double(thistrial.quest)
            % Get the coherence to test from quest
            tTest=QuestQuantile(experimentdata.q{str2double(thistrial.quest)});
            % increasing noise = harder
            noiseVar = 1 - tTest;
        elseif thistrial.addnoise(k)>0
            noiseVar = thistrial.addnoise(k);
        else
            error('Percent accurate not yet implemented for images');
        end
        
        % noise cannot be <0
        if noiseVar < 0
            noiseVar = 0;
        end
        im = double(thistrial.trialimages{k}) ./ 256;
        
        noiseType = 2;
        
        % 1 = gaussian, per pixel
        % 2 = gaussian, 5x5 blocks
        p=5;
        if noiseType == 1
            im = sqrt(noiseVar) * randn(size(im)) + im;
        elseif noiseType == 2
            thenoise = sqrt(noiseVar) * randn(size(im)/p);
            noise_expanded = zeros(size(im));
            for m=1:size(im,1)/p
                for n=1:size(im,2)/p
                    noise_expanded((m-1)*p + (1:5),(n-1)*p + (1:5)) = thenoise(m,n);
                end
            end
            im = noise_expanded + im;
        end
        thistrial.trialimages{k} = uint8(im*256);
    end
    if ~isempty(thistrial.trialalpha{k}) && length(size(thistrial.trialimages{k}))<3
        thistrial.trialimages{k} = thistrial.trialimages{k} .* uint8(thistrial.trialalpha{k} / max(max(thistrial.trialalpha{k})));
    end
    if size(thistrial.stimuli,2)==6
        centerlocation = thistrial.stimuli(k,5:6);
        thissize = size(thistrial.trialimages{k});
        % left top right bottom
        thistrial.imagerectangle(k,1) = centerlocation(1)* experimentdata.screenInfo.screenRect(3) - ceil(thissize(1)/2);
        thistrial.imagerectangle(k,2) = centerlocation(2)* experimentdata.screenInfo.screenRect(4) - floor(thissize(2)/2);
        thistrial.imagerectangle(k,3) = thistrial.imagerectangle(k,1) + thissize(1) - 1;
        thistrial.imagerectangle(k,4) = thistrial.imagerectangle(k,2) + thissize(2) - 1;
    else
        thistrial.imagerectangle = [];
    end
    
end

for p=1:length(thistrial.trialimages)
    thistrial.textures(p) = Screen('MakeTexture',experimentdata.screenInfo.curWindow,thistrial.trialimages{p});
end

thistrial.stimuliFrames = round((thistrial.recordingTime - thistrial.waitTimeBefore)*experimentdata.screenInfo.monRefresh);
