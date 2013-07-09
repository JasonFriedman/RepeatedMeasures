% FINISHTRIAL - whether this trial should be finished at this time
% This should not be run directly, it is called by runexperiment.m

function [toFinish,thistrial,experimentdata] = finishTrial(r,thistrial,experimentdata,e,lastposition)

toFinish = false;
devices = get(e,'devices');
lastsample = getsample(devices.liberty);
if length(lastsample)<2
    return;
end

if ~isfield(thistrial,'currentlyTouching')
    thistrial.currentlyTouching = 0;
end

if ~isfield(thistrial,'untouchTime')
    thistrial.untouchTime = [];
end

if ~isfield(thistrial,'touchTime')
    thistrial.touchTime = [];
end

if ~isfield(thistrial,'touched')
    thistrial.touched = [];
end


% calculate the fingertip position
for k=1:5
    rng = r.fingermarkers(k)*6-4 : r.fingermarkers(k)*6-2;
    rngOrientation = r.fingermarkers(k)*6-1:r.fingermarkers(k)*6+1;
    aer = degtorad(lastsample(rngOrientation));
    ca = cos(aer(1)); sa = sin(aer(1));
    ce = cos(aer(2)); se = sin(aer(2));
    cr = cos(aer(3)); sr = sin(aer(3));
    attitudeMatrix = [ca*ce, ca*se*sr - sa*cr, ca*se*cr + sa * sr;
        sa*ce, ca*cr + sa*se*sr, sa*se*cr - ca * sr;
        -se,   ce*sr,            ce*cr;];   % from p10 of the Liberty manual
    fingertip(k,:) = lastsample(rng) + r.fingertipdistance * attitudeMatrix(:,3)';
    if k>1
        thumbfingerdistance(k-1) = sqrt(sum((fingertip(k,:) - fingertip(1,:)).^2));
    end
end

if thistrial.currentlyTouching>0
    % check if no longer touching
    if thumbfingerdistance(thistrial.currentlyTouching) > r.untouchThreshold
        thistrial.untouchTime = [thistrial.untouchTime; thistrial.currentlyTouching GetSecs];
        thistrial.currentlyTouching = 0;
    end
else
    for k=1:4
        % check if touching
        if thumbfingerdistance(k) < r.touchThreshold
            thistrial.touchTime = [thistrial.touchTime; k GetSecs];
            thistrial.currentlyTouching = k;
            
            thistrial.touched = [thistrial.touched k];
            
            % If this is the next element in the series
            if thistrial.currentlyTouching == thistrial.fingersequence(thistrial.sequenceposition+1)
                thistrial.sequenceposition = thistrial.sequenceposition+1
                if thistrial.sequenceposition==numel(thistrial.fingersequence)
                    toFinish = true;
                end
            end
            
            break;
        end
    end
end

%[thistrial.currentlyTouching thumbfingerdistance]

[keyIsDown, secs, keycode] = KbCheck;
if ~isempty(find(keycode,1)) && (find(keycode,1)==KbName('q') || find(keycode,1)==KbName('n'))
    toFinish = true;
end
