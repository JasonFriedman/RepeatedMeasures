% MAKEBOUNCINGDOT - Make a dot that bounces off the 'walls'

function positions = makeBouncingDot(startPosition,startAngle,velocity,numFrames,toplot)

if nargin<5
    toplot = 0;
end

position = startPosition;
angle = startAngle;

for frame=1:numFrames
    newposition = position + [velocity*cos(angle) velocity*sin(angle)];
    
    % If it hits the left or right, flip the x component
    if newposition(1)<0
        angle = pi - angle;
        newposition(1)=0;
    elseif newposition(1)>1
        angle = pi - angle;
        newposition(1)  =1;
    end
    
    % If it hits the top or bottom, flip the y component
    if newposition(2)>1
        angle = -angle;
        newposition(2) = 1;
    elseif newposition(2)<0
        angle = -angle;
        newposition(2) = 0;
    end
    
    if angle>2*pi
        angle = angle - 2*pi;
    elseif angle<0
        angle = angle + 2*pi;
    end
    position = newposition;
    positions(frame,:) = newposition;
    
end

if toplot
    figure;
    for k=1:size(positions,1)
        hold off;
        plot(positions(k,1),positions(k,2),'k.','MarkerSize',6);
        axis([0 1 0 1]);
        drawnow;
    end
end
