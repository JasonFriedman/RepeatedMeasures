% RENDER_FINGERTIPS Draw only the fingertip positions 
% 
% The fingertip location is calculated using the Virtualhand SDK
% 
% This function will set the jointangles of the cyberglove
% It will set the tracker positions and orientation as well
% and draw the hand offscreen

function render_fingertips(gtc, jointangles, positions, orientations, vr, winptr, isflipped,showPositionFingers)

translation = vr.translation;
scale = vr.scale;
cameraRotation = vr.rotate;
stereo = vr.stereomode;
eye_distance = vr.eyedistance;

positions(1) = positions(1) * scale(1)  +  translation(1);
positions(2) = positions(2) * scale(2)  +  translation(2);
positions(3) = positions(3) * scale(3)  +  translation(3);

global GL;
Screen('BeginOpenGL', winptr);
% We only want lighting for drawing the glove
glEnable( GL.LIGHTING );
if gtc.noVHT
    %
else
    % pass the glove joint angles
    Glove_Rendering(1, jointangles);
    % pass the position and orientation of the fastrak
    %orientations
    Glove_Rendering(3, positions, orientations);
end

if stereo==0
    glClear();
    if gtc.noVHT
        ;%
    else
        fingertippositions = Glove_Rendering(7, [0 0 0],[1 1 1],cameraRotation);
        for m=find(showPositionFingers)
            glPushMatrix;
            glColor3d(0,0,0);	
            glTranslated(fingertippositions(m*3-2),fingertippositions(m*3-1),fingertippositions(m*3));
            glutSolidSphere(1,100,100);
            glPopMatrix;
        end
    end
else
    for k=[0 1]
        if (k==1 && isflipped) || (k==0 && ~isflipped)
            ed = eye_distance/2;
        else
            ed = -eye_distance/2;
        end
        Screen('EndOpenGL', winptr);
        Screen('SelectStereoDrawBuffer', winptr, k);
        Screen('BeginOpenGL', winptr);
        glClear();
        if gtc.noVHT
            %
        else
            fingertippositions = Glove_Rendering(7, [ed 0 0],[1 1 1],cameraRotation);
            for m=find(showPositionFingers)
                glPushMatrix;
                glColor3d(0,0,0);
                glTranslated(fingertippositions(m*3-2),fingertippositions(m*3-1),fingertippositions(m*3));
                glutSolidSphere(1,100,100);
                glPopMatrix;
            end
        end
    end
end
glDisable( GL.LIGHTING );
Screen('EndOpenGL', winptr );