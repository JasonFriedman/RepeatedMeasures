% READVISUALRESOURCES - read in resources that will be displayed (and depend on the screen size)

function experimentdata = readVisualResources(e,experimentdata)

% Get some info (not sure if we need this)
if ~isempty(experimentdata.screenInfo.curWindow) % this will be empty when just validating
    spf =Screen('GetFlipInterval', experimentdata.screenInfo.curWindow);      % seconds per frame
    experimentdata.screenInfo.monRefresh = 1/spf;    % frames per second
    experimentdata.screenInfo.frameDur = 1000/experimentdata.screenInfo.monRefresh;
    experimentdata.screenInfo.center = [experimentdata.screenInfo.screenRect(3) experimentdata.screenInfo.screenRect(4)]/2;    % coordinates of screen center (pixels)
    % determine pixels per degree
    % (pix/screen) * ... (screen/rad) * ... rad/deg
    experimentdata.screenInfo.ppd = pi * experimentdata.screenInfo.screenRect(3) / atan(experimentdata.monitorWidth/experimentdata.viewingDistance/2) / 360;    % pixels per degree
    experimentdata.screenInfo.rseed = [];
end

% Convert the mouse targets to screen coordinates (if appropriate)
if ~isempty(experimentdata.mouseTargets)
    for k=1:size(experimentdata.mouseTargets,1)
        experimentdata.mouseTargets(k,[1 3]) = experimentdata.mouseTargets(k,[1 3]) * experimentdata.screenInfo.screenRect(3);
        experimentdata.mouseTargets(k,[2 4]) = experimentdata.mouseTargets(k,[2 4]) * experimentdata.screenInfo.screenRect(4);
    end
end

% Convert the boxes to screen coordinates (if appropriate)
if ~isnan(experimentdata.boxes(1))
    for k=1:size(experimentdata.boxes,1)
        experimentdata.boxes(k,[1 3]) = experimentdata.boxes(k,[1 3]) * experimentdata.screenInfo.screenRect(3);
        experimentdata.boxes(k,3) = experimentdata.boxes(k,1) + experimentdata.boxes(k,3);
        experimentdata.boxes(k,[2 4]) = experimentdata.boxes(k,[2 4]) * experimentdata.screenInfo.screenRect(4);
        experimentdata.boxes(k,4) = experimentdata.boxes(k,2) + experimentdata.boxes(k,4);
    end
end

% Read labels if appropriate (arbitrary text to display through the trials)
if ~isempty(experimentdata.labels)
    for k=1:numel(experimentdata.labels)
        experimentdata.labels{k}.location(1) = experimentdata.labels{k}.location(1) * experimentdata.screenInfo.screenRect(3);
        experimentdata.labels{k}.location(2) = experimentdata.labels{k}.location(2) * experimentdata.screenInfo.screenRect(4);
    end
end

% Put images into textures
if ~isempty(experimentdata.screenInfo.curWindow) && ~isempty(experimentdata.images)
    for k=1:numel(experimentdata.images)
        tmp = experimentdata.images{k};
        % Create a texture from the image (for faster viewing later)
        if ~isempty(experimentdata.alpha{k})
            tmp(:,:,4) = experimentdata.alpha{k};
            experimentdata.textures(k) = Screen('MakeTexture',experimentdata.screenInfo.curWindow,tmp);            
        else
            experimentdata.textures(k) = Screen('MakeTexture',experimentdata.screenInfo.curWindow,experimentdata.images{k});
        end
        tmpsize = size(tmp);
        experimentdata.imagesize(k,:) = tmpsize(1:2);
    end
end
