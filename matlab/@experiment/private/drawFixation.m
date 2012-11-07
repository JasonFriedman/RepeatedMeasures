% DRAWFIXATION - draw a fixation point

function drawFixation(experimentdata)
rect = round([experimentdata.xshift-1 -1 experimentdata.xshift+1 1]/10 * experimentdata.screenInfo.ppd + repmat(experimentdata.screenInfo.center, 1,2));
Screen('FillOval',experimentdata.screenInfo.curWindow,[255 255 255],rect);
