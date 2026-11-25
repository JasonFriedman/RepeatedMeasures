% MAKESTIMULI

function [fp,width,height] = makeStimuli(num,filename)

if nargin==0
    for k=1:2
        makeStimuli(k);
    end
    return
end

if nargin<2
    if num==1
        filename = 'stimuli/pointtoPoint.svg';
    else
        filename = 'stimuli/smilies.svg';
    end
end

if ~exist('stimuli','dir')
    mkdir('stimuli');
end

%width = 1920;
%height = 1080;

width=2560;
height=1440;

width_mm = 520; % mm
height_mm = 291; % mm

fp = fopen(filename,'w');

startsvg(fp,width,height);

% black background as in the experiment
drawRectangleFullScreen(fp,'black');

if num==1 % point to point
    
    % circles should be 30 cm apart, 8 cm diameter (4 cm radius), from the
    % van der Wel paper
    circle_distance_mm = 300; % mm
    circle_radius_mm = 40; % mm
    
    % circles center
    
    y = height/2; % middle of the screen
    x = (width_mm/2 + [- circle_distance_mm/2, + circle_distance_mm/2]) ./ width_mm * width;

    circle_radius = circle_radius_mm / width_mm * width;
    
    circlecolor = 'blue';
    outlinecolor = 'blue';
    
    linewidth = 4;
   
    drawCircle(fp,x(1),y,circle_radius,linewidth,outlinecolor,circlecolor);
    drawCircle(fp,x(2),y,circle_radius,linewidth,outlinecolor,circlecolor);
else
   % Draw the square (half the height of the screen)   
   squareside = height/2;
   x = width/2 - squareside/2;
   y = height/2 - squareside/2;
   
   color = 'black';
   outlinecolor = 'white';
   
   drawSquare(fp,x,y,squareside,4,outlinecolor,color);
end

if nargin<2
    endsvg(fp) 
    fclose(fp);
end
