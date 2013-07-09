% SETUP - Prepare a "textArray" trial
% Do not call directly, will be called by runexperiment

function thistrial = setup(s,e,thistrial,experimentdata)

array = repmat(' ',s.rows,s.columns);

array(s.positions) = s.character;

array = [array repmat('\n',s.rows,1)];
array = array';

thistrial.textArraytext = array(1:end);

Screen('TextFont', experimentdata.screenInfo.curWindow, 'Courier New');
Screen('TextSize', experimentdata.screenInfo.curWindow, 16);
Screen('TextStyle', experimentdata.screenInfo.curWindow, 0);

[nx,ny,textBounds] = DrawFormattedText(experimentdata.screenInfo.curWindow, thistrial.textArraytext,0,0,thistrial.backgroundColor);

% desired x value in pixels
% viewing angle:
% V = 2 * arctan(S/2D); % see wikipedia
S_horizontal_cm = 2* experimentdata.viewingDistance * tan(s.visualAngleHorizontal/180*pi/2); % desired height in cm
S_horizontal_pixels = S_horizontal_cm / experimentdata.monitorWidth * experimentdata.screenInfo.screenRect(3);

thistrial.textArrayFontSize = round(S_horizontal_pixels / textBounds(3)* 16);

Screen('TextSize', experimentdata.screenInfo.curWindow, thistrial.textArrayFontSize);
[nx,ny,textBounds] = DrawFormattedText(experimentdata.screenInfo.curWindow, thistrial.textArraytext,0,0,thistrial.backgroundColor);

thistrial.viewingAngleHorizontal = 2 * atan(textBounds(3)*experimentdata.monitorWidth/experimentdata.screenInfo.screenRect(3)/(2*experimentdata.viewingDistance)) * 180/pi;
thistrial.viewingAngleVertical = 2 * atan(textBounds(4)*experimentdata.monitorHeight/experimentdata.screenInfo.screenRect(4)/(2*experimentdata.viewingDistance)) * 180/pi;

% Show for the whole trial
thistrial.stimuliFrames = thistrial.recordingTime * experimentdata.screenInfo.monRefresh;


