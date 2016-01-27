% FEEDBACK - Provide feedback for reaching target on the screen
% This should not be run directly, it is called by runexperiment.m

function thistrial = feedback(r,e,thistrial,previoustrial,experimentdata,dataSummary)

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
end
