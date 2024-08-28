% FEEDBACK - Provide feedback for reaching target on the screen
% This should not be run directly, it is called by runexperiment.m

function thistrial = feedback(r,e,thistrial,previoustrial,experimentdata,dataSummary,results)

if ~isempty(r.showBackground)
     Screen('DrawTexture',experimentdata.screenInfo.curWindow,experimentdata.textures(r.showBackground));
end

%if isfield(thistrial,'finishtime')
%    trialduration = thistrial.finishtime - thistrial.starttime;
%end

if (~isempty(r.showPathFeedback) && r.showPathFeedback) || ~isempty(r.durationFeedback)
    % Use the first device to calculate in screen coordinates
    devices = get(e,'devices');
    devicelist = fields(devices);
    d = devices.(devicelist{1});
    if ~isa(d,'libertyclient')
        error('showPath feedback currently only works with liberty client');
    end
    xyz = dataSummary.markerpos(:,1:3);
end

% Show duration feedback if necessary
if ~isempty(r.durationFeedback) && r.durationFeedback(1)>=0 && r.durationFeedback(2)<inf
    % Start at the end, go backwards until the last time it is in the start target
    startsample = NaN;
    for k=size(xyz,1):-1:1
        lastposition = calculateLastPosition(d,xyz(k,:),thistrial,inf);
        lastposition(1) = round(lastposition(1) *  experimentdata.screenInfo.screenRect(3));
        lastposition(2) = round(lastposition(2) *  experimentdata.screenInfo.screenRect(4));
        pixelColor=squeeze(double(Screen('GetImage',experimentdata.textures(r.startImageNum), [lastposition(1) lastposition(2) lastposition(1)+1 lastposition(2)+1],[], 0, 3)))';
        if sum(abs(pixelColor - r.colorStart)) <= r.distance
            startsample = k;
            break;
        end
    end
    % Start at the beginning and go forwards until the first time it is in the end target
    endsample = NaN;
    for k=1:size(xyz,1)
        lastposition = calculateLastPosition(d,xyz(k,:),thistrial,inf);
        lastposition(1) = round(lastposition(1) *  experimentdata.screenInfo.screenRect(3));
        lastposition(2) = round(lastposition(2) *  experimentdata.screenInfo.screenRect(4));
        pixelColor=squeeze(double(Screen('GetImage',experimentdata.textures(r.imageNum), [lastposition(1) lastposition(2) lastposition(1)+1 lastposition(2)+1],[], 0, 3)))';
        if sum(abs(pixelColor - r.color)) <= r.distance
            endsample = k;
            break;
        end
    end
    thistrial.duration = dataSummary.time(endsample) - dataSummary.time(startsample);
    if thistrial.duration<r.durationFeedback(1)
        writetolog(e,'Duration too fast');
        thistrial.responseText = 'Too fast!';
        thistrial.textFeedback=1;
        return;
    elseif thistrial.duration>r.durationFeedback(2)
        writetolog(e,'Duration too slow');
        thistrial.responseText = 'Too slow!';
        thistrial.textFeedback=1;
        return
    end
    % Otherwise, no feedback
end

if ~isempty(r.points)
    lastposition = round(thistrial.lastposition);
    points = 0;
    for k=1:size(r.points,1)
        thisrow = r.points(k,:);
        % Rect is left,top,right,bottom
        pixelColor=squeeze(double(Screen('GetImage',experimentdata.textures(thisrow(1)), [lastposition(1) lastposition(2) lastposition(1)+1 lastposition(2)+1],[], 0, 3)))';
%        fprintf('%d points: Pixel color is %d,%d,%d compared to expected color %d,%d,%d\n',thisrow(5),pixelColor(1),pixelColor(2),pixelColor(3),thisrow(2),thisrow(3),thisrow(4));
        
        distance = thisrow(6);
        
        if sum(abs(pixelColor-thisrow(2:4))) <= distance
            points = points + thisrow(5);
            break;
        end
    end
    
    pointsText = sprintf('%d points',points);
    drawText(thistrial,experimentdata.screenInfo,'Courier',50,0,pointsText,0,[],[255 0 0],0); %1);
    WaitSecs(1);
elseif ~isempty(thistrial.showPositionFeedback)
    for k=1:size(thistrial.showPositionFeedback)
        centerlocation = thistrial.showPositionFeedback(k,3:4);
        thissize = experimentdata.imagesize(thistrial.showPositionFeedback(k,1),:);
        % left top right bottom
        imagerectangle(1) = centerlocation(1) - ceil(thissize(1)/2);
        imagerectangle(2) = centerlocation(2) - floor(thissize(2)/2);
        imagerectangle(3) = imagerectangle(1) + thissize(1) - 1;
        imagerectangle(4) = imagerectangle(2) + thissize(2) - 1;
        Screen('DrawTexture',experimentdata.screenInfo.curWindow,experimentdata.textures(thistrial.showPositionFeedback(k,1)),...
            [],imagerectangle);
    end
    Screen('Flip',experimentdata.screenInfo.curWindow,1);
    WaitSecs(1);
elseif ~isempty(r.showPathFeedback) && r.showPathFeedback
    % Need to convert to screen coordinates (every 5th dot)
    count=0;
    for k=1:5:size(xyz,1)
        count = count+1;
        [dots(:,count),thistrial] = calculateLastPosition(d,xyz(k,:),thistrial,inf);
    end
    
    dots(1,:) = dots(1,:) * experimentdata.screenInfo.screenRect(3);
    dots(2,:) = dots(2,:) * experimentdata.screenInfo.screenRect(4);

    thesize = 4;
    thecolor = [110 110 100];
    thetype = 2;
        
    Screen('DrawDots', experimentdata.screenInfo.curWindow, dots, thesize , thecolor,[],thetype);
    Screen('Flip',experimentdata.screenInfo.curWindow,1);
    WaitSecs(2);
end

