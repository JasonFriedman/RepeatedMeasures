% MAKEINSTRUCTIONS - make instructions text

function makeInstructions

if ~exist('stimuli','dir')
    mkdir('stimuli');
end

filename = 'stimuli/instructions_mirrorgame.svg';

fp = fopen(filename,'w');

%width = 1920;
%height = 1080;

width=2560;
height=1440;

width_mm = 520; % mm
height_mm = 291; % mm

startsvg(fp,width,height);

% black background as in the experiment
drawRectangleFullScreen(fp,'black');

% Draw the ellipses

ellipsesize = [72 144]; % from generateProtocol
offset2 = 0.65; % relative position of the blue ellipse

% ellipse center
x = 0.5 * width;
y = (1-offset2)*height;
x2 = 0.53 * width;
y2 = offset2 * height;

stimulicolor = 'red';
drawEllipse(fp,x,y,ellipsesize(1),ellipsesize(2),0,stimulicolor,stimulicolor);

playercolor = 'blue';
drawEllipse(fp,x2,y2,ellipsesize(1),ellipsesize(2),0,playercolor,playercolor);

text = 'The red ellipse will move left and right. By moving the stylus (pen) left and right, you will control the position of the blue ellipse. You should track the motion of the red ellipse with the blue ellipse as well as you can'; 
textHebrew = 'האליפסה האדומה תנועה שמאלה וימינה. על ידי הזזת העט לימין או לשמאל תוכל/י לשלוט במיקום האליפסה הכחולה. עליך לעקוב כמיטב יכולתך באמצעות האליפסה הכחולה אחרי האליפסה האדומה';
textRussian = 'Красный эллипс будет двигаться влево и вправо. Перемещая стилус (ручку) влево и вправо, Вы можете управлять положением синего эллипса. Вы должны управлять движением синего эллипса так, чтобы он повторял траекторию движения красного эллипса насколько возможно точно';

fontsize =  60;

boxwidth = 0.4 * width;
boxheight = height/2;

drawWrappedText(fp,50,50,boxwidth,boxheight,text,fontsize,'white');
drawWrappedText(fp,width-boxwidth-50,50,boxwidth,boxheight,textHebrew,fontsize,'white',[],'right');
drawWrappedText(fp,50,height-boxheight,boxwidth,boxheight,textRussian,fontsize,'white');

endsvg(fp)
fclose(fp);

