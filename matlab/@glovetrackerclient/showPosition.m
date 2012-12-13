% SHOWPOSITION - show the position of the hand in space

function [lastposition,thistrial] = showPosition(gfc,thistrial,experimentdata,e,frame)
% set some default values for rendering the hand
jointangles = zeros(1,23);
positions = [0 0 0];
orientations = [90 0 0];

lastposition = NaN * ones(1,30);

codes = messagecodes;

% This only should render the hand if the stimulus is "vr"
if ~isa(thistrial.thisstimulus,'vrstimulus')
    return;
end
lastsample =getsample(gfc);
if isfield(lastsample,'glove')
    jointangles = lastsample.glove(2:24);
end
if isfield(lastsample,'tracker')
    positions = lastsample.tracker(2:4);
    if strcmp(gfc.trackerType,'liberty')
        orientations = lastsample.tracker([7 6 5]);
    else
        orientations = lastsample.tracker(5:7);
    end
end

if frame>0
    % For checking movement, check if they moved compared to the last frame
    if ~isempty(thistrial.movementonset) && thistrial.movementonset.type==-1 && isfield(thistrial,'previouspos')
        % You need to move forward (i.e. in the negative z direction) to start the trial
        if thistrial.movementonset.direction<0
            moved = (positions(-thistrial.movementonset.direction) - thistrial.previouspos(-thistrial.movementonset.direction)) < - thistrial.movementonset.threshold;
        else
            moved = (positions(thistrial.movementonset.direction) - thistrial.previouspos(thistrial.movementonset.direction)) > thistrial.movementonset.threshold;
        end
        if moved
            fprintf('Movement onset reached\n');
            now = thistrial.frameInfo.startFrame(frame) - thistrial.frameInfo.startFrame(1);
            thistrial.thisstimulus = set(thistrial.thisstimulus,'stimuliOffTime',now);
            targets = get(thistrial.thisstimulus,'target');
            for k=1:numel(targets)
                targets{k}.offTime = now;
            end
            thistrial.thisstimulus = set(thistrial.thisstimulus,'target',targets);
            thistrial.movementonset.type = frame;
        end
    end
    thistrial.previouspos = positions;
    
    if (thistrial.frameInfo.startFrame(frame) - thistrial.frameInfo.startFrame(1) >= get(thistrial.thisstimulus,'stimuliOnTime')) && ...
            (thistrial.frameInfo.startFrame(frame) - thistrial.frameInfo.startFrame(1) <= get(thistrial.thisstimulus,'stimuliOffTime'))
        if ~isfield(thistrial,'markedStartStimulus')
            markEvent(e,codes.stimulusOn);
            thistrial.markedStartStimulus = 1;
        end
        
        timearray = get(thistrial.thisstimulus,'timeshift');
        positionarray = get(thistrial.thisstimulus,'positionshift');
        orientationarray = get(thistrial.thisstimulus,'orientationshift');
        angleshift = get(thistrial.thisstimulus,'angleshift');
        
        if ~isempty(timearray) && numel(timearray) >= frame % i.e. is there a shift
            timelag = timearray(frame);
            previousjointangles = getprevioussample(gfc.glove, timelag);
            if isempty(previousjointangles)
                previousjointangles = lastsample.glove;
            end
            jointangles = previousjointangles(2:24);
            if ~isempty(angleshift) && ~isempty(angleshift.transform) && size(angleshift.transform,1) >= frame
                if isempty(experimentdata.basejointangles)
                    error('To use the joint angle transformations, you must record first a baseline (set experimentDescription.trial{1}.stimulus.vr.basejointangles = 1)');
                end
                jointangles = squeeze(angleshift.transform(frame,:,:)) * (jointangles - experimentdata.basejointangles)' + experimentdata.basejointangles' + angleshift.offset(frame,:)';
            end
            previoustracker = getprevioussample(gfc.tracker, timelag);
            if isempty(previoustracker)
                previoustracker = lastsample.tracker(1:7);
            end
            lastposition = [previousjointangles previoustracker];
            positions = previoustracker(2:4) + positionarray(frame,:);
            orientations = previoustracker(5:7) + orientationarray(frame,:);
        end
        
        % Whether to render the hand or just the fingertip positions
        spt = get(thistrial.thisstimulus,'showPositionType');
        
        if strcmp(spt,'hand')
            render_hand(gfc,jointangles, positions, orientations, experimentdata.vr,experimentdata.screenInfo.curWindow,...
                get(thistrial.thisstimulus,'showFlipped'));
        elseif strcmp(spt,'fingertips')
            render_fingertips(gfc,jointangles,positions,orientations,experimentdata.vr,experimentdata.screenInfo.curWindow,...
                get(thistrial.thisstimulus,'showFlipped'),get(thistrial.thisstimulus,'showPositionFingers'));
        else
            error(['Unknown value for showPositionType ' spt]);
        end
    end
end
