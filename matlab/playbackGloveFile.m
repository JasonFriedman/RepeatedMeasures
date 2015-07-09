% PLAYBACKGLOVEFILE - playback a glove movement. The file should be cg_?????.csv
% Also see the GUI version - playbackGlove, which allows chaning the
% viewing angle and seeing the joint angle / velocities simultaneously

function playbackGloveFile(filename)

l = logfilegenerator();
inputparams.glove.gloveemulator = struct();
inputparams.tracker.fixedtracker = struct();

debug = 1;
gtc = glovetrackerclient(inputparams,l,debug);

gc = get(gtc,'glove');

data = load(filename);

% In place of setupRecording
data(:,1) = data(:,1) - data(1,1);

% ignore the last column
data = data(:,1:24);
gc = set(gc,'data',data);
gtc = set(gtc,'glove',gc);
InitializeMatlabOpenGL;

curScreen = 0;
cameralocation = [0 15 30];
center = [0 0 0];
up = [0 0 -1];

m = 2;
frustum.left = -m;
frustum.right = m;
frustum.bottom = -m;
frustum.top = m;
frustum.nearVal = 2;
frustum.farVal = 500;
ed = 0;

[winptr,rect]=Screen('OpenWindow',curScreen,[255 255 255],[100 100 500 500]);

Screen('BeginOpenGL', winptr);
global GL;

glMatrixMode( GL.PROJECTION );
glLoadIdentity;
glFrustum( frustum.left,frustum.right,frustum.bottom,frustum.top,frustum.nearVal,frustum.farVal);

% gluLookAt is the eye (xyz), the centre (xyz) and the up vector (xyz)
gluLookAt(cameralocation(1)+ed,cameralocation(2),cameralocation(3),center(1),center(2),center(3),up(1),up(2),up(3));

glMatrixMode( GL.MODELVIEW);
glClear(); % clear the buffer

% setup the lighting
lightPosition0 = [ 10.0 20.0 50.0 0.0 ];
lightPosition1 = [ 10.0 40.0 50.0 0.0 ];
glLightfv( GL.LIGHT0, GL.POSITION, lightPosition0 );
glLightfv( GL.LIGHT1, GL.POSITION, lightPosition1 );
glEnable( GL.LIGHT0 );
glEnable( GL.LIGHT1 );
% set shading
glShadeModel( GL.SMOOTH );
glEnable(GL.DEPTH_TEST);
glDepthFunc( GL.LEQUAL );
createHand(gtc); %create the virtual hand
Screen('EndOpenGL', winptr);

% clear the global variable to keep track of the time
global GLOVEEMULATORCLIENT_LASTTIME;
global GLOVEEMULATORCLIENT_FIRSTTIME;

GLOVEEMULATORCLIENT_LASTTIME = [];
GLOVEEMULATORCLIENT_FIRSTTIME = [];

samplenum = 0;

experimentdata.vr = '1';
vrparams.stimuliOnTime = '0';
vrparams.stimuliOffTime = 'inf';
thistrial.thisstimulus = vrstimulus(vrparams,experimentdata);
thistrial.movementonset = [];
thistrial.frameInfo.startFrame = 0;

positions = [0 0 0];
orientations = [90 0 0];
isflipped = 0;

vr.scale = [0.5 0.5 0.5];
vr.rotate = [0 0 0];
vr.translation = [-1.2 -8.1 21.6];
vr.translation = [-10.2 -8.1 21.6];
vr.stereomode = 0;
vr.eyedistance = 0.6;

% Are these used?
vr.cameralocation = [0 20 0];
vr.center = [0 0 0];
vr.up = [0 0 -1];

while(samplenum<size(data,1))
    [thissample,samplenum] = getsample(gc);
    jointangles = thissample(2:24);
    Screen('BeginOpenGL', winptr );
    glClearColor(255,255,255,0.0);
    glClear();
    Screen('EndOpenGL', winptr );
    render_hand(gtc, jointangles, positions, orientations, vr, winptr, isflipped)
    Screen('Flip', winptr);
end

Screen('Close',winptr);