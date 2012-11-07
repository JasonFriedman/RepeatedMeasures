% SETUP - Prepare a "VR" trial
% Do not call directly, will be called by runexperiment

function thistrial = setup(s,e,thistrial,experimentdata)

if ~isempty(s.calibrate)
    thistrial.recording = 0;
    thistrial.showPosition =1;
end

thistrial.stimuliFrames = round((thistrial.recordingTime - thistrial.waitTimeBefore)*experimentdata.screenInfo.monRefresh);
% setup OpenGL (frustum, etc)

setupViewingTransform(s,experimentdata,0);

global GL;
%Screen('BeginOpenGL', experimentdata.screenInfo.curWindow); % included in setupViewingTransform
%This code will setup the OPENGL properties for hand rendering
glClear(); % clear the buffer

% setup the lighting
lightPosition0 = [ 10.0 20.0 50.0 0.0 ];
lightPosition1 = [ 10.0 40.0 50.0 0.0 ];
%lightPosition2 = [ 0.0 0.0 -25.0 0.0 ];
%lightPosition3 = [ -25.0 -60.0 70.0 0.0 ];
glLightfv( GL.LIGHT0, GL.POSITION, lightPosition0 );
glLightfv( GL.LIGHT1, GL.POSITION, lightPosition1 );
%glLightfv( GL.LIGHT2, GL.POSITION, lightPosition2 );
%glLightfv( GL.LIGHT3, GL.POSITION, lightPosition3 );
glEnable( GL.LIGHT0 );
glEnable( GL.LIGHT1 );
% set shading
glShadeModel( GL.SMOOTH );
glEnable(GL.DEPTH_TEST);
glDepthFunc( GL.LEQUAL );

Screen('EndOpenGL', experimentdata.screenInfo.curWindow );

