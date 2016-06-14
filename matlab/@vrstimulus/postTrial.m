function [thistrial,experimentdata] = postTrial(s,dataSummary,thistrial,experimentdata,e)
% POSTTRIAL - do anything that needs to be done post-trial

% Clear the screen
global GL;
Screen('BeginOpenGL', experimentdata.screenInfo.curWindow);
glDisable( GL.LIGHTING );
glDisable( GL.LIGHT0 );
glDisable( GL.LIGHT1 );
glClearColor(0.0,0.0,0.0,0.0);
glClear();
Screen('EndOpenGL', experimentdata.screenInfo.curWindow);

if s.basejointangles
    experimentdata.basejointangles = dataSummary.meanjointangles(2:24);
end

% Wait for them to let go of a keyboard if they pressed it to end the trial
while(KbCheck(-1))
    % do nothing
end
